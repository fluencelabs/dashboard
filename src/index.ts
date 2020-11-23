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

import {Elm} from './Main.elm';
import * as serviceWorker from './serviceWorker';
import {peerIdToSeed, seedToPeerId} from "fluence/dist/seed";
import Fluence from "fluence";
import {build} from "fluence/dist/particle";
import {registerService} from "fluence/dist/globalState";
import {Service} from "fluence/dist/service";

function genFlags(peerId: string): any {
    return {
        peerId: peerId,
        windowSize: {
            width: window.innerWidth,
            height: window.innerHeight,
        }
    }
}

(async () => {

    let pid = await Fluence.generatePeerId()

    let flags = genFlags(pid.toB58String())
    let app = Elm.Main.init({
        node: document.getElementById('root'),
        flags: flags
    });

    let service = new Service("custom")
    service.registerFunction("func", (args: any[]) => {
        console.log("call")
        return {}
    })
    registerService(service)

    let client = await Fluence.connect(relays[1].multiaddr, pid)

    let script = `(call self_peer ("custom" "func") [])`

    let data = new Map()
    data.set("self_peer", client.selfPeerIdStr)

    let particle = await build(client.selfPeerId, script, data)
    await client.sendParticle(particle)

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