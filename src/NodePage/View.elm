module NodePage.View exposing (..)

import Dict exposing (Dict)
import Html exposing (Html, div, p, table, tbody, td, text, th, thead, tr)
import Html.Attributes exposing (attribute)
import Model exposing (Model)
import Palette exposing (classes, redFont)
import SpinnerView exposing (spinner)


type alias Node =
    { id : String
    , ip : String
    , servicesNumber : Int
    }


view : Model -> Html msg
view model =
    let
        nodes =
            modelToNodes model

        finalView =
            if List.isEmpty nodes then
                spinner model

            else
                [ div [ classes "fl w-100 cf ph2-ns" ]
                    [ div [ classes "fl w-100 mb2 pt4 pb4" ]
                        [ div [ redFont, classes "f1 fw4 pt3" ] [ text "Network Nodes" ]
                        ]
                    , div [ classes "fl w-100 mt2 mb4 bg-white br3" ] [ nodesView nodes ]
                    ]
                ]
    in
    div [] finalView


modelToNodes : Model -> List Node
modelToNodes model =
    let
        getIp =
            \data -> data.identify.external_addresses |> List.head |> Maybe.withDefault "unknown"
    in
    model.discoveredPeers
        |> Dict.toList
        |> List.map (\( peer, data ) -> { id = peer, ip = getIp data, servicesNumber = List.length data.services })


nodesView : List Node -> Html msg
nodesView nodes =
    div [ classes "pa1 bg-white br3 overflow-auto" ]
        [ div [ classes "mw8-ns pa2 " ]
            [ table [ classes "f6 w-100 center ws-normal-ns", attribute "cellspacing" "0" ]
                [ thead []
                    [ tr [ classes "" ]
                        [ th [ classes "fw5 tl pa3 gray-font" ] [ text "NODE ID" ]
                        , th [ classes "fw5 tl pa3 gray-font" ] [ text "MULTIADDR" ]
                        , th [ classes "fw5 tl pa3 gray-font dn dtc-ns" ] [ text "SERVICES" ]
                        ]
                    ]
                , tbody [ classes "lucida" ] (nodes |> List.map viewNode)
                ]
            ]
        ]


viewNode : Node -> Html msg
viewNode node =
    tr [ classes "table-red-row" ]
        [ td [ classes "ph3" ] [ p [ classes "ws-normal" ] [ text node.id ] ]
        , td [ classes "ph3" ] [ p [ classes "ws-normal" ] [ text node.ip ] ]
        , td [ classes "ph3 dn dtc-ns" ] [ p [ classes "ws-normal" ] [ text (String.fromInt node.servicesNumber) ] ]
        ]
