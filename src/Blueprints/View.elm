module Blueprints.View exposing (..)

import Blueprints.Model exposing (Blueprint, BlueprintInfo)
import Dict exposing (Dict)
import Html exposing (Html, a, div, span, text)
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
    div [ classes "cf" ] servicesView


viewService : BlueprintInfo -> Html msg
viewService blueprint =
    div [ classes "fl w-100 w-third-ns pr3 lucida" ]
        [ a [ attribute "href" ("/blueprint/" ++ blueprint.id)
            , classes "fl w-100 bg-white black mw6 mr3 mb3 hide-child pv3 pl4 br3 element-box ba b--white bw2 no-underline"
            ]
            [ div [ classes "w-100 mb3 pt1 b f3 overflow-hidden" ] [ text blueprint.name ]
            , div [ classes "w-100 mb4 fw4 gray-font" ] [ text "By ", span [classes "lucida-in normal"] [text blueprint.author] ]
            , div [ classes "w-100 mt1 lucida gray-font" ] [ instancesText blueprint.instanceNumber ]
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
