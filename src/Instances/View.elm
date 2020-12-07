module Instances.View exposing (..)

import Blueprints.Model exposing (Blueprint)
import Dict exposing (Dict)
import Html exposing (Html, div, p, table, tbody, td, text, th, thead, tr)
import Html.Attributes exposing (attribute, style)
import Instances.Model exposing (Instance)
import Model exposing (Model)
import Nodes.Model exposing (Identify)
import Palette exposing (classes, shortHashRaw)
import Service.Model exposing (Service)


toInstance : String -> Identify -> Dict String Blueprint -> Service -> Instance
toInstance peerId identify blueprints service =
    let
        name =
            blueprints |> Dict.get service.blueprint_id |> Maybe.map .name |> Maybe.withDefault "unknown"

        ip =
            List.head identify.external_addresses |> Maybe.map (String.split "/") |> Maybe.map (List.drop 2) |> Maybe.andThen List.head |> Maybe.withDefault "unknown"
    in
    { name = name, instance = service.service_id, peerId = peerId, ip = ip }


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
    div [ classes "pa1 mt2 bg-white br3" ]
        [ div [ classes "mw8-ns pa2 " ]
            [ table [ classes "f6 w-100 center ws-normal-ns", attribute "cellspacing" "0", style "word-break" "break-all" ]
                [ thead []
                    [ tr [ classes "" ]
                        [ th [ classes "fw6 tl pa3 gray" ] [ text "SERVICE" ]
                        , th [ classes "fw6 tl pa3 gray" ] [ text "INSTANCE" ]
                        , th [ classes "fw6 tl pa3 gray" ] [ text "NODE" ]
                        , th [ classes "fw6 tl pa3 gray" ] [ text "IP" ]
                        ]
                    ]
                , tbody [ classes "lucida" ] (instances |> List.map viewInstance)
                ]
            ]
        ]


viewInstance : Instance -> Html msg
viewInstance instance =
    tr [ classes "" ]
        [ td [ classes "ph3" ] [ p [classes "ws-normal"] [text instance.name ]]
        , td [ classes "ph3" ] [ p [classes "ws-normal"] [text instance.instance ]]
        , td [ classes "ph3" ] [ p [classes "ws-normal"] [text (shortHashRaw 8 instance.peerId) ]]
        , td [ classes "ph3" ] [ p [classes "ws-normal"] [text instance.ip ]]
        ]
