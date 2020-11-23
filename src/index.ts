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

function genFlags(peerId: string): any {
    return {
        peerId: peerId,
        windowSize: {
            width: window.innerWidth,
            height: window.innerHeight,
        }
    }
}

// If you want your app to work offline and load faster, you can change
// unregister() to register() below. Note this comes with some pitfalls.
// Learn more about service workers: https://bit.ly/CRA-PWA
serviceWorker.unregister();

function test() {
    console.log("test")
}

declare global {
    interface Window {
        test: any;
    }
}

window.test = test;
