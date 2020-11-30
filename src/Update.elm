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

import AirScripts.GetAll
import Blueprints.Model exposing (Blueprint)
import Browser
import Browser.Navigation as Nav
import Dict exposing (Dict)
import Maybe exposing (withDefault)
import Model exposing (Model, PeerData, emptyPeerData)
import Msg exposing (..)
import Nodes.Model exposing (Identify)
import Port exposing (sendAir)
import Route
import Services.Model exposing (Service)
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
            ( { model | url = url, page = route }, cmd )

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
                    ( { model | discoveredPeers = updatedDict }, Cmd.none )

                "all_info" ->
                    let
                        updated =
                            Maybe.map4 (updateModel model peer) identify services modules blueprints

                        updatedModel =
                            withDefault model updated

                        byBp =
                            peersByBlueprintId model.discoveredPeers "623c6d14-2204-43c4-84d5-a237bcd19874"

                        _ =
                            Debug.log "by blueprint id" byBp
                    in
                    ( updatedModel, Cmd.none )

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
                    in
                    ( { model | discoveredPeers = updatedDict }, Cmd.none )

                _ ->
                    let
                        _ =
                            Debug.log "event in ELM" name
                    in
                    ( model, Cmd.none )

        Click command ->
            case command of
                "get_all" ->
                    ( model
                    , sendAir (AirScripts.GetAll.air model.peerId model.relayId (Dict.keys model.discoveredPeers))
                    )

                _ ->
                    ( model, Cmd.none )

        RelayChanged relayId ->
            ( { model | relayId = relayId }, Cmd.none )


updateModel : Model -> String -> Identify -> List Service -> List String -> List Blueprint -> Model
updateModel model peer identify services modules blueprints =
    let
        data =
            Maybe.withDefault emptyPeerData (Dict.get peer model.discoveredPeers)

        newData =
            { data | identify = identify, services = services, modules = modules, blueprints = blueprints }

        updated =
            Dict.insert peer newData model.discoveredPeers
    in
    { model | discoveredPeers = updated }


peersByModule : Dict String PeerData -> String -> List String
peersByModule peerData moduleId =
    let
        list =
            Dict.toList peerData

        found =
            list |> List.filter (\( _, pd ) -> existsByModule moduleId pd.modules) |> List.map (\( peer, _ ) -> peer)
    in
    found


existsByModule : String -> List String -> Bool
existsByModule moduleId modules =
    modules |> List.any (\m -> m == moduleId)


peersByBlueprintId : Dict String PeerData -> String -> List String
peersByBlueprintId peerData blueprintId =
    let
        list =
            Dict.toList peerData

        found =
            list |> List.filter (\( _, pd ) -> existsByBlueprintId blueprintId pd.blueprints) |> List.map (\( peer, _ ) -> peer)
    in
    found


existsByBlueprintId : String -> List Blueprint -> Bool
existsByBlueprintId id bps =
    bps |> List.any (\b -> b.id == id)
