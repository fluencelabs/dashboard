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
import {Elm} from './Main.elm';
import * as serviceWorker from './serviceWorker';
import {peerIdToSeed, seedToPeerId} from "fluence/dist/seed";
import Fluence from "fluence";
import {build} from "fluence/dist/particle";
import {registerService} from "fluence/dist/globalState";
import {Service, ServiceMultiple, ServiceOne} from "fluence/dist/service";

let relayIdx = 1

function genFlags(peerId: string): any {
    return {
        peerId: peerId,
        relayId: relays[relayIdx].peerId
    }
}

function event(name: string, peer: string, peers?: string[], identify?: string[], services?: any[], blueprints?: string[], modules?: string[]) {
    if (!peers) { peers = null }
    if (!services) { services = null }
    if (!modules) { modules = null }
    if (!identify) { identify = null }
    if (!blueprints) { blueprints = null }

    return {name, peer, peers, identify, services, modules, blueprints}
}

(async () => {

    let pid = await Fluence.generatePeerId()

    let flags = genFlags(pid.toB58String())

    // If the relay is ever changed, an event shall be sent to elm
    let client = await Fluence.connect(relays[relayIdx].multiaddr, pid)

    let app = Elm.Main.init({
        node: document.getElementById('root'),
        flags: flags
    });

    let eventService = new ServiceOne("event", (fnName, args: any[]) => {
        console.log("event service called: ", fnName)
        console.log("from: ", args[0])
        console.log("event service args: ", args)

        try {
            if (fnName === "peers_discovered") {
                app.ports.eventReceiver.send(event(fnName, args[0], args[1]))
            } else if (fnName === "all_info") {
                app.ports.eventReceiver.send(event(fnName, args[0], undefined, args[1], args[2], args[3], args[4]))
            } else {
                console.error("UNHANDLED")
            }
        } catch (err) {
            console.error(err)
        }





        return {}
    })
    registerService(eventService)

    app.ports.sendParticle.subscribe(async(part: any) => {
        console.log("Going to build particle", part)
        let jsonData = part.data;

        let map = new Map<string, string>()
        for (let v in jsonData) if(jsonData.hasOwnProperty(v)) {
            map.set(v,jsonData[v])
        }

        let particle = await build(client.selfPeerId, part.script, map)
        await client.sendParticle(particle)
    })

})();

// If you want your app to work offline and load faster, you can change
// unregister() to register() below. Note this comes with some pitfalls.
// Learn more about service workers: https://bit.ly/CRA-PWA
serviceWorker.unregister();

async function test() {


}

declare global {
    interface Window {
        test: any;
    }
}

window.test = test;

export let relays: { peerId: string; multiaddr: string }[] = [
    {
        multiaddr: "/dns4/stage.fluence.dev/tcp/19001/wss/p2p/12D3KooWEXNUbCXooUwHrHBbrmjsrpHXoEphPwbjQXEGyzbqKnE9",
        peerId: "12D3KooWEXNUbCXooUwHrHBbrmjsrpHXoEphPwbjQXEGyzbqKnE9"
    },
    {
        multiaddr: "/dns4/stage.fluence.dev/tcp/19002/wss/p2p/12D3KooWHk9BjDQBUqnavciRPhAYFvqKBe4ZiPPvde7vDaqgn5er",
        peerId: "12D3KooWHk9BjDQBUqnavciRPhAYFvqKBe4ZiPPvde7vDaqgn5er"
    },
    {
        multiaddr: "/dns4/stage.fluence.dev/tcp/19003/wss/p2p/12D3KooWBUJifCTgaxAUrcM9JysqCcS4CS8tiYH5hExbdWCAoNwb",
        peerId: "12D3KooWBUJifCTgaxAUrcM9JysqCcS4CS8tiYH5hExbdWCAoNwb"
    },
    {
        multiaddr: "/dns4/stage.fluence.dev/tcp/19004/wss/p2p/12D3KooWJbJFaZ3k5sNd8DjQgg3aERoKtBAnirEvPV8yp76kEXHB",
        peerId: "12D3KooWJbJFaZ3k5sNd8DjQgg3aERoKtBAnirEvPV8yp76kEXHB"
    },
    {
        multiaddr: "/dns4/stage.fluence.dev/tcp/19005/wss/p2p/12D3KooWCKCeqLPSgMnDjyFsJuWqREDtKNHx1JEBiwaMXhCLNTRb",
        peerId: "12D3KooWCKCeqLPSgMnDjyFsJuWqREDtKNHx1JEBiwaMXhCLNTRb"
    },
    {
        multiaddr: "/dns4/stage.fluence.dev/tcp/19990/wss/p2p/12D3KooWMhVpgfQxBLkQkJed8VFNvgN4iE6MD7xCybb1ZYWW2Gtz",
        peerId: "12D3KooWMhVpgfQxBLkQkJed8VFNvgN4iE6MD7xCybb1ZYWW2Gtz"
    },
    {
        multiaddr: "/dns4/stage.fluence.dev/tcp/19100/wss/p2p/12D3KooWPnLxnY71JDxvB3zbjKu9k1BCYNthGZw6iGrLYsR1RnWM",
        peerId: "12D3KooWPnLxnY71JDxvB3zbjKu9k1BCYNthGZw6iGrLYsR1RnWM"
    }
]