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
import './main.css';
// eslint-disable-next-line import/no-extraneous-dependencies
import log from 'loglevel';
import { Node, dev, testNet } from '@fluencelabs/fluence-network-environment';
import { createClient, generatePeerId, Particle, sendParticle, subscribeToEvent } from '@fluencelabs/fluence';
import { Elm } from './Main.elm';
import * as serviceWorker from './serviceWorker';

const relayIdx = 3;

// const relays: Node[] = testNet;
const relays: Node[] = dev;

function genFlags(peerId: string): any {
    return {
        peerId,
        relayId: relays[relayIdx].peerId,
        knownPeers: relays.map((v) => v.peerId),
    };
}

/* eslint-disable */
function event(
    name: string,
    peer: string,
    peers?: string[],
    identify?: string[],
    services?: any[],
    blueprints?: string[],
    modules?: string[],
) {
    if (!peers) {
        peers = null;
    }
    if (!services) {
        services = null;
    }
    if (!modules) {
        modules = null;
    }
    if (!identify) {
        identify = null;
    }
    if (!blueprints) {
        blueprints = null;
    }

    return { name, peer, peers, identify, services, modules, blueprints };
}
/* eslint-enable */

(async () => {
    const pid = await generatePeerId();
    const flags = genFlags(pid.toB58String());

    // If the relay is ever changed, an event shall be sent to elm
    const client = await createClient(relays[relayIdx].multiaddr, pid);

    const app = Elm.Main.init({
        node: document.getElementById('root'),
        flags,
    });

    subscribeToEvent(client, 'event', 'peers_discovered', (args, _tetraplets) => {
        try {
            app.ports.eventReceiver.send(event('peers_discovered', args[0], args[1]));
        } catch (err) {
            log.error('Elm eventreceiver failed: ', err);
        }
    });

    subscribeToEvent(client, 'event', 'all_info', (args, _tetraplets) => {
        try {
            app.ports.eventReceiver.send(event('all_info', args[0], undefined, args[1], args[2], args[3], args[4]));
        } catch (err) {
            log.error('Elm eventreceiver failed: ', err);
        }
    });

    app.ports.sendParticle.subscribe(async (part: { script: string; data: any }) => {
        const particle = new Particle(part.script, part.data, 45000);
        await sendParticle(client, particle);
    });
})();

// If you want your app to work offline and load faster, you can change
// unregister() to register() below. Note this comes with some pitfalls.
// Learn more about service workers: https://bit.ly/CRA-PWA
serviceWorker.unregister();

declare global {
    interface Window {
        test: any;
    }
}
