module Main exposing (..)

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

import Browser
import Browser.Navigation as Navigation
import Cache
import MainPage exposing (..)
import Route
import RoutePage
import Url


type alias Config =
    { peerId : String
    , relayId : String
    , knownPeers : List String
    }


type alias Flags =
    Config


main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }


init : Flags -> Url.Url -> Navigation.Key -> ( Model, Cmd Msg )
init flags url key =
    let
        r =
            Route.parse url

        c =
            Cache.init

        newPagesModel =
            RoutePage.fromCache r c

        emptyModel =
            { peerId = flags.peerId
            , relayId = flags.relayId
            , url = url
            , key = key
            , page = r
            , pageModel = newPagesModel
            , cache = c
            , toggledInterface = Nothing
            , knownPeers = flags.knownPeers
            , isInitialized = False
            }
    in
    ( emptyModel, routeCommand emptyModel r )
