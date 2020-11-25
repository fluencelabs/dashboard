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

import Browser
import Browser.Navigation as Nav
import Dict
import Json.Decode exposing (decodeValue, list, string)
import Json.Encode exposing (Value)
import Maybe exposing (withDefault)
import Model exposing (Model, emptyPeerData)
import Msg exposing (..)
import Port exposing (sendAir)
import Route
import Services.Air
import Url


maybeValueToString : Maybe Value -> String
maybeValueToString mv =
    case mv of
        Just v ->
            case decodeValue string v of
                Ok value ->
                    value

                Err error ->
                    "error"

        Nothing ->
            ""



-- list of lists of strings in json to list of strings from first element if it is an array


maybeValueToListString : Maybe Value -> List String
maybeValueToListString mv =
    case mv of
        Just v ->
            case decodeValue (list (list string)) v of
                Ok value ->
                    Maybe.withDefault [] (List.head value)

                Err error ->
                    let
                        _ =
                            Debug.log "error" error
                    in
                    case decodeValue (list string) v of
                        Ok value ->
                            value

                        Err err ->
                            let
                                _ =
                                    Debug.log "err" err
                            in
                            [ "error" ]

        Nothing ->
            []


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        UrlChanged url ->
            let
                route =
                    Route.parse url

                cmd =
                    Route.routeCommand model route
            in
            ( { model | url = url }, cmd )

        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        AquamarineEvent { name, peer, peers, services, modules } ->
            case name of
                "peers_discovered" ->
                    let
                        peersMap =
                            List.map (\p -> Tuple.pair p emptyPeerData) (withDefault [] peers)

                        newDict =
                            Dict.fromList peersMap

                        updatedDict =
                            Dict.union model.discoveredPeers newDict
                    in
                    ( { model | discoveredPeers = updatedDict }, Cmd.none )

                "services_discovered" ->
                    let
                        newServices =
                            Maybe.withDefault [] services

                        empty =
                            emptyPeerData

                        up =
                            \old -> Just (Maybe.withDefault { empty | services = newServices } (Maybe.map (\o -> { o | services = newServices }) old))

                        updatedDict =
                            Dict.update peer up model.discoveredPeers

                        _ =
                            Debug.log "discovered" updatedDict
                    in
                    ( { model | discoveredPeers = updatedDict }, Cmd.none )

                "modules_discovered" ->
                    let
                        newModules =
                            Maybe.withDefault [] modules

                        empty =
                            emptyPeerData

                        up =
                            \old -> Just (Maybe.withDefault { empty | modules = newModules } (Maybe.map (\o -> { o | modules = newModules }) old))

                        updatedDict =
                            Dict.update peer up model.discoveredPeers

                        _ =
                            Debug.log "discovered" updatedDict
                    in
                    ( { model | discoveredPeers = updatedDict }, Cmd.none )

                _ ->
                    let
                        _ =
                            Debug.log "event in ELM" name
                    in
                    ( model, Cmd.none )

        Click ->
            ( model
            , sendAir (Services.Air.air model.peerId model.relayId (Dict.keys model.discoveredPeers))
            )

        RelayChanged relayId ->
            ( { model | relayId = relayId }, Cmd.none )
