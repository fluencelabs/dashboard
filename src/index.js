/*
 * Copyright 2020 Fluence Labs Limited
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import 'tachyons/css/tachyons.min.css';
import 'css-spinners/dist/all.min.css';
import './main.css';
// eslint-disable-next-line import/no-extraneous-dependencies
import log from 'loglevel';
import Multiaddr from 'multiaddr';
import { stage, kras, testNet } from '@fluencelabs/fluence-network-environment';
import { Fluence } from '@fluencelabs/js-client.api';
import { Elm } from './Main.elm';
import * as serviceWorker from './serviceWorker';
import { interfaceInfo, peerInfo } from './types';
import { askAllAndSend, getAll } from './_aqua/app';

const defaultNetworkName = 'testNet + kras';

const relays = [...kras, ...stage];

const defaultEnv = {
    relays,
    relayIdx: Math.floor(Math.random() * relays.length),
    logLevel: 'error',
};

async function loadScript(script) {
    return new Promise((resolve, reject) => {
        var xhr = new XMLHttpRequest();
        xhr.open('GET', script.src);
        xhr.onreadystatechange = function () {
            if (xhr.readyState === XMLHttpRequest.DONE && xhr.status === 200) {
                resolve(xhr.responseText);
            }
        };
        xhr.onerror = reject;
        xhr.onabort = reject;
        xhr.send();
    });
}

function isMultiaddr(multiaddr) {
    try {
        Multiaddr(multiaddr);
        return true;
    } catch (error) {
        return false;
    }
}

async function initEnvironment() {
    try {
        const script = document.getElementById('env');
        if (!script) {
            console.log("Couldn't load environment, falling back to default (${defaultNetworkName})");
            return defaultEnv;
        }

        const scriptContent = await loadScript(script);
        const envWrapper = JSON.parse(scriptContent);

        const res = { ...defaultEnv };

        const data = envWrapper ? envWrapper.nodes : [];
        if (data.length === 0) {
            console.log(`Environment is empty, falling back to default (${defaultNetworkName})`);
        } else {
            data.forEach((element) => {
                if (!element.multiaddr) {
                    console.error('multiaddr field is missing for ', element);
                }
                if (!element.peerId) {
                    console.error('peerId field is missing for ', element);
                }
                if (!isMultiaddr(element.multiaddr)) {
                    console.error(`Value ${element.multiaddr} is not a correct multiaddr`);
                }
            });
            res.relays = data;
            res.relayIdx = 0;
        }

        if (envWrapper.logLevel !== undefined) {
            res.logLevel = envWrapper.logLevel;
        }

        return res;
    } catch (error) {
        console.error("Couldn't parse environment, error: ", error);
    }

    return defaultEnv;
}

function genFlags(peerId, relays, relayIdx) {
    return {
        peerId,
        relayId: relays[relayIdx].peerId,
        knownPeers: relays.map((v) => v.peerId),
    };
}

(async () => {
    const { relays, relayIdx, logLevel } = await initEnvironment();
    log.setLevel(logLevel);
    // it will use random key pair by default
    await Fluence.connect(relays[relayIdx].multiaddr);
    const client = await Fluence.getClient();
    const pid = client.getPeerId();
    const flags = genFlags(pid, relays, relayIdx);
    console.log(`Own peer id: ${pid}`);

    // If the relay is ever changed, an event shall be sent to elm

    const app = Elm.Main.init({
        node: document.getElementById('root'),
        flags: flags,
    });

    if (window) {
        window.collectedData = {
            // service ids
            services: new Map(),
            // services per creator
            creators: new Map(),
            // blueprints used in services
            serviceBlueprints: new Set(),
            // all blueprints
            blueprints: new Map(),
            // module hashes used in services
            serviceModules: new Set(),
            // unique module names used in services
            moduleNames: new Set(),
            // all modules
            modules: new Map(),
            // peer infos per PeerId
            peerInfos: new Map(),
        };

        window.showStat = () => {
            /*
                1490 users created 3018 services
                from 280 blueprints
                from 299 modules of which there are 43 unique module names
            */
            let usersCount = window.collectedData.creators.size;
            let serviceCount = window.collectedData.services.size;
            let blueprintCount = window.collectedData.serviceBlueprints.size;
            let moduleCount = window.collectedData.serviceModules.size;
            let nameCount = window.collectedData.moduleNames.size;
            let totalModules = window.collectedData.modules.size;

            console.log(`${usersCount} users created ${serviceCount} services`);
            console.log(`from ${blueprintCount} blueprints`);
            console.log(`from ${moduleCount} modules of which there are ${nameCount} unique module names`);
            console.log(`total ${totalModules} modules were uploaded`);

            let servicesPerHost = new Map();
            for (let service of window.collectedData.services.values()) {
                let perHost = servicesPerHost.has(service.host) ? servicesPerHost.get(service.host) : new Set();
                perHost.add(service.id);
                servicesPerHost.set(service.host, perHost);
            }

            let N = 10;
            let sorted = [...servicesPerHost.entries()].sort((a, b) => b[1].size - a[1].size);
            console.log(`top ${N} nodes by hosted services:`);
            let slice = sorted.slice(0, 10);
            for (let entry of slice) {
                console.log(`\t node ${entry[0]} has ${entry[1].size} services`);
            }

            let byNodeVersion = new Map();
            let byAirVersion = new Map();
            for (let info of window.collectedData.peerInfos.values()) {
                let byNodeCount = byNodeVersion.get(info.node_version) || 0;
                byNodeVersion.set(info.node_version, byNodeCount + 1);
                let byAirCount = byAirVersion.get(info.air_version) || 0;
                byAirVersion.set(info.air_version, byAirCount + 1);
            }

            console.log('Nodes version distribution:');
            for (let entry of byNodeVersion.entries()) {
                let version = entry[0];
                let count = entry[1];
                console.log(`\t${version}: ${count} nodes`);
            }

            console.log('AIR intepreter versions distribution:');
            for (let entry of byAirVersion.entries()) {
                let version = entry[0];
                let count = entry[1];
                console.log(`\t${version}: ${count} nodes`);
            }
        };
    }

    function collectStats(peerId, identify, services, blueprints, modules) {
        if (window) {
            window.collectedData.peerInfos.set(peerId, identify);

            for (let blueprint of blueprints) {
                window.collectedData.blueprints.set(blueprint.id, blueprint);
            }

            for (let module of modules) {
                window.collectedData.modules.set(module.hash, module);
            }

            for (let service of services) {
                service.host = peerId;
                window.collectedData.services.set(service.id, service);
                window.collectedData.serviceBlueprints.add(service.blueprint_id);

                let blueprint = window.collectedData.blueprints.get(service.blueprint_id);
                for (let prefixedHash of blueprint.dependencies) {
                    let moduleHash = prefixedHash.split(':')[1];
                    window.collectedData.serviceModules.add(moduleHash);

                    let module = window.collectedData.modules.get(moduleHash);
                    window.collectedData.moduleNames.add(module.name);
                }

                let perCreator = window.collectedData.creators.has(service.owner_id)
                    ? window.collectedData.creators.get(service.owner_id)
                    : new Set();
                perCreator.add(service.id);
                window.collectedData.creators.set(service.owner_id, perCreator);
            }
        }
    }

    // alias ServiceInterfaceCb: PeerId, string, Interface -> ()
    function collectServiceInterface(peer_id, service_id, iface) {
        // console.count(`service interface from ${peer_id}`);
        try {
            const eventRaw = {
                peer_id,
                service_id,
                interface: iface,
            };

            app.ports.collectServiceInterface.send(eventRaw);
        } catch (err) {
            log.error('Elm eventreceiver failed: ', err);
        }
    }

    // alias PeerInfoCb: PeerId, Info, []Service, []Blueprint, []Module -> ()
    function collectPeerInfo(peerId, identify, services, blueprints, modules, interfaces) {
        // console.log('peer info from %s, %s services', peerId, services.length);
        try {
            collectStats(peerId, identify, services, blueprints, modules);

            const eventRaw = {
                // HACK: show AIR interpreter version in the NODE ID field
                peerId: peerId + ' (' + identify.air_version + ')',
                identify,
                services,
                blueprints,
                modules,
            };

            app.ports.collectPeerInfo.send(eventRaw);
        } catch (err) {
            log.error('Elm eventreceiver failed: ', err);
        }
    }

    app.ports.getAll.subscribe(async (data) => {
        // for (let peer of data.knownPeers) {
        //     await askAllAndSend(peer, collectPeerInfo, collectServiceInterface, {
        //         ttl: 120000,
        //     });
        // }

        await getAll(data.knownPeers, collectPeerInfo, collectServiceInterface, { ttl: 120000 });
    });
})();

// If you want your app to work offline and load faster, you can change
// unregister() to register() below. Note this comes with some pitfalls.
// Learn more about service workers: https://bit.ly/CRA-PWA
serviceWorker.unregister();
