module Instances.View exposing (..)

import Dict exposing (Dict)
import Html exposing (Html, div, table, tbody, td, text, th, thead, tr)
import Html.Attributes exposing (attribute)
import Instances.Model exposing (Instance)
import Model exposing (Model)
import Nodes.Model exposing (Identify)
import Palette exposing (classes)
import Services.Model exposing (Service)


toInstance : String -> Identify -> Dict String String -> Service -> Instance
toInstance peerId identify blueprints service =
    let
        name =
            blueprints |> Dict.get service.blueprint_id |> Maybe.withDefault "unknown"

        ip =
            List.head identify.external_addresses |> Maybe.withDefault "unknown"
    in
    { name = name, instance = service.service_id, peerId = peerId, ip = ip }


view : Model -> Html msg
view model =
    let
        bps =
            Dict.values model.discoveredPeers |> List.map (\data -> data.blueprints |> List.map (\b -> ( b.id, b.name )))

        bpsDict =
            List.concat bps |> Dict.fromList

        instances =
            Dict.toList model.discoveredPeers
                |> List.map
                    (\( peer, data ) ->
                        data.services
                            |> List.map (toInstance peer data.identify bpsDict)
                    )
                |> List.concat
    in
    viewTable instances


viewTable : List Instance -> Html msg
viewTable instances =
    div [ classes "pa4" ]
        [ div [ classes "" ]
            [ table [ classes "f6 w-100 mw8 center", attribute "cellspacing" "0" ]
                [ thead []
                    [ tr [ classes "stripe-dark" ]
                        [ th [ classes "fw6 tl pa3 bg-white" ] [ text "SERVICE" ]
                        , th [ classes "fw6 tl pa3 bg-white" ] [ text "INSTANCE" ]
                        , th [ classes "fw6 tl pa3 bg-white" ] [ text "NODE" ]
                        , th [ classes "fw6 tl pa3 bg-white" ] [ text "IP" ]
                        ]
                    ]
                , tbody [ classes "lh-copy" ] (instances |> List.map viewInstance)
                ]
            ]
        ]


viewInstance : Instance -> Html msg
viewInstance instance =
    tr [ classes "stripe-dark" ]
        [ td [ classes "pa3" ] [ text instance.name ]
        , td [ classes "pa3" ] [ text instance.instance ]
        , td [ classes "pa3" ] [ text instance.peerId ]
        , td [ classes "pa3" ] [ text instance.ip ]
        ]
