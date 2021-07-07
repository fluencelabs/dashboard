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
import { krasnodar, Node } from '@fluencelabs/fluence-network-environment';
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
import { getAll } from './_aqua/app';

const defaultNetworkName = 'krasnodar';

const localEnv = [
    {
        peerId: '12D3KooWHBG9oaVx4i3vi6c1rSBUm7MLBmyGmmbHoZ23pmjDCnvK',
        multiaddr: '/ip4/127.0.0.1/tcp/9990/ws/p2p/12D3KooWHBG9oaVx4i3vi6c1rSBUm7MLBmyGmmbHoZ23pmjDCnvK',
    },
    {
        peerId: '12D3KooWRABanQHUn28dxavN9ZS1zZghqoZVAYtFpoN7FdtoGTFv',
        multiaddr: '/ip4/127.0.0.1/tcp/9991/ws/p2p/12D3KooWRABanQHUn28dxavN9ZS1zZghqoZVAYtFpoN7FdtoGTFv',
    },
    {
        peerId: '12D3KooWFpQ7LHxcC9FEBUh3k4nSCC12jBhijJv3gJbi7wsNYzJ5',
        multiaddr: '/ip4/127.0.0.1/tcp/9992/ws/p2p/12D3KooWFpQ7LHxcC9FEBUh3k4nSCC12jBhijJv3gJbi7wsNYzJ5',
    },
];

const defaultEnv = {
    relays: krasnodar,
    relayIdx: 0,
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

    // alias PeerInfoCb: PeerId, Info, []Service, []Blueprint, []Module -> ()
    // alias ServiceInterfaceCb: PeerId, string, Interface -> ()
    function collectServiceInterface(peer_id, service_id, iface) {
        console.count(`service interface from ${peer_id}`);
        return;
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

    function collectPeerInfo(peerId, identify, services, blueprints, modules, interfaces) {
        console.log('peer info from %s, %s services', peerId, services.length);
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
        await getAll(client, data.relayPeerId, data.knownPeers, collectPeerInfo, collectServiceInterface, {
            ttl: 1000000,
        });
    });
})();

// If you want your app to work offline and load faster, you can change
// unregister() to register() below. Note this comes with some pitfalls.
// Learn more about service workers: https://bit.ly/CRA-PWA
serviceWorker.unregister();

/*
    peer info from 12D3KooWSD5PToNiLQwKDXsu8JSysCwUt8BVUJEqCHcDe7P5h45e, 34 services
    peer info from 12D3KooWKnEqMfYo9zvfHmqTLpLdiHXPe4SVqUWcWHDJdFGrSmcA, 22 services
    peer info from 12D3KooWFtf3rfCDAfWwt6oLZYZbDfn9Vn7bv7g6QjjQxUUEFVBt, 23 services
    peer info from 12D3KooWR4cv1a8tv7pps4HH6wePNaK6gf1Hww5wcCMzeWxyNw51, 20 services
    peer info from 12D3KooWJd3HaMJ1rpLY1kQvcjRPEvnDwcXrH8mJvk7ypcZXqXGE, 28 services
    peer info from 12D3KooWCMr9mU894i8JXAFqpgoFtx6qnV1LFPSfVc3Y34N4h4LS, 18 services
    peer info from 12D3KooWEFFCZnar1cUJQ3rMWjvPQg6yMV2aXWs2DkJNSRbduBWn, 25 services
    peer info from 12D3KooWFEwNWcHqi9rtsmDhsYcDbRUCDXH84RC4FW6UfsFWaoHi, 24 services
    peer info from 12D3KooWDUszU2NeWyUVjCXhGEt1MoZrhvdmaQQwtZUriuGN1jTr, 24 services
    peer info from 12D3KooWHLxVhUQyAuZe6AHMB29P7wkvTNMn7eDMcsqimJYLKREf, 50 services
    peer info from 12D3KooWD7CvsYcpF9HE9CCV9aY3SJ317tkXVykjtZnht2EbzDPm, 17 services
    
    /dns4/kras-00.fluence.dev/tcp/19990/wss/p2p/12D3KooWSD5PToNiLQwKDXsu8JSysCwUt8BVUJEqCHcDe7P5h45e
    /dns4/kras-02.fluence.dev/tcp/19001/wss/p2p/12D3KooWHLxVhUQyAuZe6AHMB29P7wkvTNMn7eDMcsqimJYLKREf
    /dns4/kras-03.fluence.dev/tcp/19001/wss/p2p/12D3KooWJd3HaMJ1rpLY1kQvcjRPEvnDwcXrH8mJvk7ypcZXqXGE

    /dns4/kras-00.fluence.dev/tcp/19001/wss/p2p/12D3KooWR4cv1a8tv7pps4HH6wePNaK6gf1Hww5wcCMzeWxyNw51
    /dns4/kras-01.fluence.dev/tcp/19001/wss/p2p/12D3KooWKnEqMfYo9zvfHmqTLpLdiHXPe4SVqUWcWHDJdFGrSmcA
    /dns4/kras-04.fluence.dev/tcp/19001/wss/p2p/12D3KooWFEwNWcHqi9rtsmDhsYcDbRUCDXH84RC4FW6UfsFWaoHi
    /dns4/kras-05.fluence.dev/tcp/19001/wss/p2p/12D3KooWCMr9mU894i8JXAFqpgoFtx6qnV1LFPSfVc3Y34N4h4LS
    /dns4/kras-06.fluence.dev/tcp/19001/wss/p2p/12D3KooWDUszU2NeWyUVjCXhGEt1MoZrhvdmaQQwtZUriuGN1jTr
    /dns4/kras-07.fluence.dev/tcp/19001/wss/p2p/12D3KooWEFFCZnar1cUJQ3rMWjvPQg6yMV2aXWs2DkJNSRbduBWn
    /dns4/kras-08.fluence.dev/tcp/19001/wss/p2p/12D3KooWFtf3rfCDAfWwt6oLZYZbDfn9Vn7bv7g6QjjQxUUEFVBt
    /dns4/kras-09.fluence.dev/tcp/19001/wss/p2p/12D3KooWD7CvsYcpF9HE9CCV9aY3SJ317tkXVykjtZnht2EbzDPm
*/
