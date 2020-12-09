module Model exposing (..)

{-| Copyright 2020 Fluence Labs Limited

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

-}

import Blueprints.Model exposing (Blueprint)
import Browser.Navigation as Nav
import Dict exposing (Dict)
import Modules.Model exposing (Module)
import Nodes.Model exposing (Identify, emptyIdentify)
import Service.Model exposing (Service)
import Url


type Route
    = Page String
    | Blueprint String
    | Module String
    | Peer String


type alias PeerData =
    { identify : Identify
    , services : List Service
    , modules : List String
    , blueprints : List String
    }


emptyPeerData : PeerData
emptyPeerData =
    { identify = emptyIdentify, services = [], modules = [], blueprints = [] }


type alias Model =
    { peerId : String
    , relayId : String
    , key : Nav.Key
    , url : Url.Url
    , page : Route
    , discoveredPeers : Dict String PeerData
    , modules : Dict String Module
    , blueprints : Dict String Blueprint
    , toggledInterface : Maybe String
    , knownPeers : List String
    , isInitialized : Bool
    }
