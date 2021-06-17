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

import Blueprints.Model exposing (Blueprint)
import Browser
import Browser.Navigation as Nav
import Dict exposing (Dict)
import Maybe exposing (withDefault)
import Model exposing (Model, PeerData, emptyPeerData)
import Modules.Model exposing (Module)
import Msg exposing (..)
import Nodes.Model exposing (Identify)
import Port exposing (getAll)
import Route exposing (getAllCmd)
import Service.Model exposing (Service, setInterface)
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

        CollectServiceInterface { peer_id, service_id, interface } ->
            let
                service =
                    Dict.get service_id model.services

                updatedServices =
                    Dict.update service_id (Maybe.map (setInterface interface)) model.services

                newModel =
                    { model | services = updatedServices }
            in
            ( newModel, Cmd.none )

        CollectPeerInfo { peerId, identify, services, modules, blueprints } ->
            let
                fromServiceInfo =
                    \si ->
                        { id = si.id
                        , blueprint_id = si.blueprint_id
                        , owner_id = si.owner_id
                        , interface = Nothing
                        }

                servicesCorrectType =
                    services |> Maybe.map (List.map fromServiceInfo)

                updated =
                    Maybe.map4 (updateModel model peerId) identify servicesCorrectType modules blueprints

                updatedModel =
                    withDefault model updated
            in
            ( updatedModel, Cmd.none )

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
            ( model, getAll { relayPeerId = model.relayId, knownPeers = model.knownPeers } )


updateModel : Model -> String -> Identify -> List Service -> List Module -> List Blueprint -> Model
updateModel model peer identify services modules blueprints =
    let
        data =
            Maybe.withDefault emptyPeerData (Dict.get peer model.discoveredPeers)

        servicesDict =
            services |> List.map (\m -> ( m.id, m )) |> Dict.fromList

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
            { data | identify = identify, modules = Dict.keys moduleDict, blueprints = Dict.keys blueprintDict }

        updated =
            Dict.insert peer newData model.discoveredPeers
    in
    { model
        | discoveredPeers = updated
        , services = servicesDict
        , modules = updatedModules
        , modulesByHash = updatedModulesByHash
        , blueprints = updatedBlueprints
    }
