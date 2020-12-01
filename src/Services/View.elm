module Services.View exposing (..)

import Blueprints.Model exposing (Blueprint)
import Dict exposing (Dict)
import Html exposing (Html, div, text)
import Html.Attributes exposing (attribute)
import Model exposing (Model, PeerData)
import Palette exposing (classes)
import Services.Model exposing (Service, ServiceInfo)
import Utils.Utils exposing (instancesText)


view : Model -> Html msg
view model =
    let
        allBps =
            getBlueprintsToServices model.blueprints model.discoveredPeers

        info =
            Dict.values allBps |> List.map (\( bp, servicesByPeers ) -> { name = bp.name, author = "Fluence Labs", instanceNumber = List.length (servicesByPeers |> List.map (\( _, s ) -> s) |> List.concat) })

        servicesView =
            List.map viewService info
    in
    div [ classes "cf ph1-ns" ] servicesView


viewService : ServiceInfo -> Html msg
viewService service =
    div [ classes "fl w-third-ns pa2" ]
        [ div [ attribute "href" "#", classes "fl w-100 link dim black mw5 dt hide-child ba b-black pa4 br2 solid" ]
            [ div [ classes "w-100 mb2 b" ] [ text service.name ]
            , div [ classes "w-100 mb4" ] [ text ("By " ++ service.author) ]
            , div [ classes "w-100" ] [ instancesText service.instanceNumber ]
            ]
        ]



--                                       bpId           peerId


getBlueprintsToServices : Dict String Blueprint -> Dict String PeerData -> Dict String ( Blueprint, List ( String, List Service ) )
getBlueprintsToServices blueprints peerData =
    let
        allBlueprints =
            Dict.values blueprints

        bpsToServices =
            allBlueprints |> List.map (\bp -> ( bp.id, ( bp, getServicesByBlueprintId peerData bp.id ) )) |> Dict.fromList
    in
    bpsToServices


getServicesByBlueprintId : Dict String PeerData -> String -> List ( String, List Service )
getServicesByBlueprintId peerData bpId =
    let
        list =
            Dict.toList peerData

        found =
            list |> List.map (\( peer, pd ) -> ( peer, filterServicesByBlueprintId bpId pd ))

        filtered =
            found |> List.filter (\( _, services ) -> not (List.isEmpty services))
    in
    filtered


filterServicesByBlueprintId : String -> PeerData -> List Service
filterServicesByBlueprintId blueprintId peerData =
    peerData.services |> List.filter (\s -> s.blueprint_id == blueprintId)
