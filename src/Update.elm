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

import AirScripts.GetAll as GetAll
import Blueprints.Model exposing (Blueprint)
import Browser
import Browser.Navigation as Nav
import Dict exposing (Dict)
import Maybe exposing (withDefault)
import Model exposing (Model, PeerData, emptyPeerData)
import Modules.Model exposing (Module)
import Msg exposing (..)
import Nodes.Model exposing (Identify)
import Port exposing (sendAir)
import Route exposing (getAllCmd)
import Service.Model exposing (Service)
import Url


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
            ( { model | url = url, isInitialized = True, page = route, toggledInterface = Nothing }, cmd )

        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        AquamarineEvent { name, peer, peers, identify, services, modules, blueprints } ->
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
                    ( { model | discoveredPeers = updatedDict }, getAllCmd model.peerId model.relayId [] )

                "all_info" ->
                    let
                        updated =
                            Maybe.map4 (updateModel model peer) identify services modules blueprints

                        updatedModel =
                            withDefault model updated
                    in
                    ( updatedModel, Cmd.none )

                _ ->
                    ( model, Cmd.none )

        ToggleInterface id ->
            case model.toggledInterface of
                Just ti ->
                    ( { model
                        | toggledInterface =
                            if id == ti then
                                Nothing

                            else
                                Just id
                      }
                    , Cmd.none
                    )

                Nothing ->
                    ( { model | toggledInterface = Just id }, Cmd.none )

        RelayChanged relayId ->
            ( { model | relayId = relayId }, Cmd.none )

        Reload ->
            ( model, sendAir (GetAll.air model.peerId model.relayId model.knownPeers) )


updateModel : Model -> String -> Identify -> List Service -> List Module -> List Blueprint -> Model
updateModel model peer identify services modules blueprints =
    let
        data =
            Maybe.withDefault emptyPeerData (Dict.get peer model.discoveredPeers)

        moduleDict =
            modules |> List.map (\m -> ( m.name, m )) |> Dict.fromList

        moduleDictByHash =
            modules |> List.map (\m -> ( m.hash, m )) |> Dict.fromList

        blueprintDict =
            blueprints |> List.map (\b -> ( b.id, b )) |> Dict.fromList

        updatedModules =
            Dict.union moduleDict model.modules

        updatedModulesByHash =
            Dict.union moduleDictByHash model.modulesByHash

        updatedBlueprints =
            Dict.union blueprintDict model.blueprints

        newData =
            { data | identify = identify, services = services, modules = Dict.keys moduleDict, blueprints = Dict.keys blueprintDict }

        updated =
            Dict.insert peer newData model.discoveredPeers
    in
    { model | discoveredPeers = updated, modules = updatedModules, modulesByHash = updatedModulesByHash, blueprints = updatedBlueprints }
