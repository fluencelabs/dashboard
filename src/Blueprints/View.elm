module Blueprints.View exposing (..)

import Blueprints.Model exposing (Blueprint, BlueprintInfo)
import Dict exposing (Dict)
import Html exposing (Html, a, div, text)
import Html.Attributes exposing (attribute)
import Model exposing (Model, PeerData)
import Palette exposing (classes)
import Service.Model exposing (Service)
import Utils.Utils exposing (instancesText)


view : Model -> Html msg
view model =
    let
        allBps =
            getBlueprintsToServices model.blueprints model.discoveredPeers

        info =
            Dict.values allBps
                |> List.map
                    (\( bp, servicesByPeers ) ->
                        { name = bp.name
                        , id = bp.id
                        , author = "Fluence Labs"
                        , instanceNumber = List.length (servicesByPeers |> List.map (\( _, s ) -> s) |> List.concat)
                        }
                    )

        servicesView =
            List.map viewService info
    in
    div [ classes "cf ph1-ns" ] servicesView


viewService : BlueprintInfo -> Html msg
viewService blueprint =
    div [ classes "fl w-third-ns pa2" ]
        [ a [ attribute "href" ("/blueprint/" ++ blueprint.id), classes "fl bg-white w-100 black mw6 mh2 pa3 ph4 br2 ba b--white bw1 element-box" ]
            [ div [ classes "w-100 mb2 b" ] [ text blueprint.name ]
            , div [ classes "w-100 mb4" ] [ text ("By " ++ blueprint.author) ]
            , div [ classes "w-100" ] [ instancesText blueprint.instanceNumber ]
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
