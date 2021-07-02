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

import Browser.Navigation as Nav
import Cache
import Pages.Hub
import Pages.NodesPage
import Url


type Route
    = Page String
    | Blueprint String
    | Module String
    | Peer String


type alias PageModel =
    { hub : Pages.Hub.Model
    , nodes : Pages.NodesPage.Model
    }


type alias Model =
    { peerId : String
    , relayId : String
    , key : Nav.Key
    , url : Url.Url
    , page : Route
    , pageModel : PageModel
    , cache : Cache.Model
    , toggledInterface : Maybe String
    , knownPeers : List String
    , isInitialized : Bool
    }
