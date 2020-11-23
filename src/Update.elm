module Update exposing (update)

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

import Air
import Model exposing (Model)
import Msg exposing (..)
import Port exposing (sendAir)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        UrlChange u ->
            ( model, Cmd.none )

        Request u ->
            ( model, Cmd.none )

        Event { name, args } ->
            let
                a =
                    Debug.log "event in ELM" name
            in
            ( model, Cmd.none )

        Click ->
            ( model
            , sendAir <| Air.event "hello" []
            )

        RelayChanged relayId ->
            ( { model | relayId = relayId }, Cmd.none )
