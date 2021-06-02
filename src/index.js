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
import { dev, testNet } from '@fluencelabs/fluence-network-environment';
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
import { eventType } from './types';

const relayIdx = 3;

const relays = testNet;
// const relays = dev;

function genFlags(peerId) {
    return {
        peerId,
        relayId: relays[relayIdx].peerId,
        knownPeers: relays.map((v) => v.peerId),
    };
}

/* eslint-disable */
function event(name, peer, peers, identify, services, modules, blueprints) {
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
    setLogLevel('silent');

    const pid = await generatePeerId();
    const flags = genFlags(pid.toB58String());
    console.log(`connect with client: ${pid.toB58String()}`);

    // If the relay is ever changed, an event shall be sent to elm
    const client = await createClient(relays[relayIdx].multiaddr, pid);

    const app = Elm.Main.init({
        node: document.getElementById('root'),
        flags: flags,
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
            const peerId = args[0];
            const identify = args[1];
            const services = args[2];
            const blueprints = args[3];
            const modules = args[4];
            const eventRaw = {
                peerId,
                identify,
                services,
                blueprints,
                modules,
            };

            const inputEvent = eventType.cast(eventRaw);

            console.log(eventRaw);

            app.ports.eventReceiver.send(
                event(
                    'all_info',
                    inputEvent.peerId,
                    undefined,
                    inputEvent.identify,
                    inputEvent.services,
                    inputEvent.modules,
                    inputEvent.blueprints,
                ),
            );
        } catch (err) {
            log.error('Elm eventreceiver failed: ', err);
        }
    });

    app.ports.sendParticle.subscribe(async (part) => {
        const particle = new Particle(part.script, part.data, 45000);
        await sendParticle(client, particle);
    });
})();

// If you want your app to work offline and load faster, you can change
// unregister() to register() below. Note this comes with some pitfalls.
// Learn more about service workers: https://bit.ly/CRA-PWA
serviceWorker.unregister();
