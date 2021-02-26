module Instances.View exposing (..)

import Blueprints.Model exposing (Blueprint)
import Dict exposing (Dict)
import Html exposing (Html, a, div, p, table, tbody, td, text, th, thead, tr)
import Html.Attributes exposing (attribute)
import Instances.Model exposing (Instance)
import Model exposing (Model)
import Nodes.Model exposing (Identify)
import Palette exposing (classes, shortHashRaw)
import Service.Model exposing (Service)


toInstance : String -> Identify -> Dict String Blueprint -> Service -> Instance
toInstance peerId identify blueprints service =
    let
        bp =
            blueprints |> Dict.get service.blueprint_id

        name =
            bp |> Maybe.map .name |> Maybe.withDefault "unknown"

        blueprintId =
            bp |> Maybe.map .id |> Maybe.withDefault "#"

        ip =
            List.head identify.external_addresses
                --|> Maybe.map (String.split "/")
                --|> Maybe.map (List.drop 2)
                --|> Maybe.andThen List.head
                |> Maybe.withDefault "unknown"
    in
    { name = name, blueprintId = blueprintId, instance = service.id, peerId = peerId, ip = ip }


view : Model -> (Service -> Bool) -> ( Int, Html msg )
view model filter =
    let
        instances =
            Dict.toList model.discoveredPeers
                |> List.map
                    (\( peer, data ) ->
                        data.services
                            |> List.filter filter
                            |> List.map (toInstance peer data.identify model.blueprints)
                    )
                |> List.concat
    in
    ( List.length instances, viewTable instances )


viewTable : List Instance -> Html msg
viewTable instances =
    div [ classes "pa1 bg-white br3 overflow-auto" ]
        [ div [ classes "mw8-ns pa2 " ]
            [ table [ classes "f6 w-100 center ws-normal-ns", attribute "cellspacing" "0" ]
                [ thead []
                    [ tr [ classes "" ]
                        [ th [ classes "fw5 tl pa3 gray-font" ] [ text "BLUEPRINT" ]
                        , th [ classes "fw5 tl pa3 gray-font" ] [ text "SERVICE ID" ]
                        , th [ classes "fw5 tl pa3 gray-font dn dtc-ns" ] [ text "NODE" ]
                        , th [ classes "fw5 tl pa3 gray-font dn dtc-ns" ] [ text "MULTIADDR" ]
                        ]
                    ]
                , tbody [ classes "lucida" ] (instances |> List.map viewInstance)
                ]
            ]
        ]


viewInstance : Instance -> Html msg
viewInstance instance =
    tr [ classes "table-red-row" ]
        [ td [ classes "ph3" ] [ p [ classes "ws-normal" ] [ a [ attribute "href" ("/blueprint/" ++ instance.blueprintId), classes "black" ] [ text instance.name ] ] ]
        , td [ classes "ph3" ] [ p [ classes "ws-normal" ] [ text instance.instance ] ]
        , td [ classes "ph3 dn dtc-ns" ] [ p [ classes "ws-normal" ] [ text (shortHashRaw 8 instance.peerId) ] ]
        , td [ classes "ph3 dn dtc-ns" ] [ p [ classes "ws-normal" ] [ text instance.ip ] ]
        ]
