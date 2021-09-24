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
import { stage, krasnodar } from '@fluencelabs/fluence-network-environment';
import {
    createClient,
    generatePeerId,
    Particle,
    sendParticle,
    subscribeToEvent,
    setLogLevel,
} from '@fluencelabs/fluence';
import { Elm } from './Main.elm';
import * as serviceWorker from './serviceWorker';
import { interfaceInfo, peerInfo } from './types';
import { askAllAndSend } from './_aqua/app';

const defaultNetworkName = 'krasnodar';

const defaultEnv = {
    relays: krasnodar,
    relayIdx: 3,
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
    setLogLevel(logLevel);
    const pid = await generatePeerId();
    const flags = genFlags(pid.toB58String(), relays, relayIdx);
    console.log(`connect with client: ${pid.toB58String()}`);

    // If the relay is ever changed, an event shall be sent to elm
    const client = await createClient(relays[relayIdx].multiaddr, pid);

    const app = Elm.Main.init({
        node: document.getElementById('root'),
        flags: flags,
    });

    subscribeToEvent(client, 'event', 'collectPeerInfo', (args, _tetraplets) => {
        try {
            const peerId = args[0];
            const identify = args[1];
            const services = args[2];
            const blueprints = args[3];
            const modules = args[4];
            const interfaces = args[5];
            const eventRaw = {
                peerId,
                identify,
                services,
                blueprints,
                modules,
            };

            app.ports.collectPeerInfo.send(eventRaw);
        } catch (err) {
            log.error('Elm eventreceiver failed: ', err);
        }
    });

    subscribeToEvent(client, 'event', 'collectServiceInterface', (args, _tetraplets) => {
        try {
            const eventRaw = {
                peer_id: args[0],
                service_id: args[1],
                interface: args[2],
            };

            app.ports.collectServiceInterface.send(eventRaw);
        } catch (err) {
            log.error('Elm eventreceiver failed: ', err);
        }
    });

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
            const eventRaw = {
                peerId,
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
        for (let peer of data.knownPeers) {
            await askAllAndSend(client, peer, collectPeerInfo, collectServiceInterface, {
                ttl: 120000,
            });
        }
    });
})();

// If you want your app to work offline and load faster, you can change
// unregister() to register() below. Note this comes with some pitfalls.
// Learn more about service workers: https://bit.ly/CRA-PWA
serviceWorker.unregister();
