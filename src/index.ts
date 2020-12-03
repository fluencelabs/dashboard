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
import Fluence from 'fluence';
import { build } from 'fluence/dist/particle';
import { registerService } from 'fluence/dist/globalState';
import { ServiceOne } from 'fluence/dist/service';
import * as serviceWorker from './serviceWorker';
import { Elm } from './Main.elm';
import { faasNetHttps, faasNet, stage } from './environments';

const relayIdx = 1;

export const relays: { peerId: string; multiaddr: string }[] = faasNetHttps;

function genFlags(peerId: string): any {
    return {
        peerId,
        relayId: relays[relayIdx].peerId,
    };
}

/* eslint-disable */
function event(name: string,peer: string,peers?: string[],identify?: string[],services?: any[],blueprints?: string[],modules?: string[],
) {
    if (!peers) { peers = null; }
    if (!services) { services = null; }
    if (!modules) { modules = null; }
    if (!identify) { identify = null; }
    if (!blueprints) { blueprints = null; }

    return { name, peer, peers, identify, services, modules, blueprints };
}
/* eslint-enable */

(async () => {
    const pid = await Fluence.generatePeerId();
    const flags = genFlags(pid.toB58String());

    // If the relay is ever changed, an event shall be sent to elm
    const client = await Fluence.connect(relays[relayIdx].multiaddr, pid);

    const app = Elm.Main.init({
        node: document.getElementById('root'),
        flags,
    });

    const eventService = new ServiceOne('event', (fnName, args: any[]) => {
        console.log('event service called: ', fnName);
        console.log('from: ', args[0]);
        console.log('event service args: ', args);

        try {
            if (fnName === 'peers_discovered') {
                app.ports.eventReceiver.send(event(fnName, args[0], args[1]));
            } else if (fnName === 'all_info') {
                app.ports.eventReceiver.send(event(fnName, args[0], undefined, args[1], args[2], args[3], args[4]));
            } else {
                console.error('UNHANDLED');
            }
        } catch (err) {
            console.error(err);
        }

        return {};
    });
    registerService(eventService);

    app.ports.sendParticle.subscribe(async (part: any) => {
        console.log('Going to build particle', part);
        const jsonData = part.data;

        const map = new Map<string, string>();
        for (const v in jsonData) {
            if (jsonData.hasOwnProperty(v)) {
                map.set(v, jsonData[v]);
            }
        }

        const particle = await build(client.selfPeerId, part.script, map);
        await client.sendParticle(particle);
    });
})();

// If you want your app to work offline and load faster, you can change
// unregister() to register() below. Note this comes with some pitfalls.
// Learn more about service workers: https://bit.ly/CRA-PWA
serviceWorker.unregister();

async function test() {}

declare global {
    interface Window {
        test: any;
    }
}

window.test = test;
