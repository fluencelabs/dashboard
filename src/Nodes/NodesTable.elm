module Nodes.NodesTable exposing (Model, fromCache, view)

import Array exposing (Array)
import Cache exposing (PeerId)
import Dict exposing (Dict)
import Html exposing (Html, div, p, table, tbody, td, text, th, thead, tr)
import Html.Attributes exposing (attribute)
import List
import Nodes.NodeRow
import Palette exposing (..)
import Utils.Html exposing (classes)



-- model


type alias Model =
    List Nodes.NodeRow.Model


fromCache : Cache.Model -> Model
fromCache cache =
    cache.nodes
        |> Dict.values
        |> List.map
            (\x ->
                { peerId = x.peerId
                , addr = Cache.firstExternalAddress x |> Maybe.withDefault "unknown"
                , numberOfServices = Array.length x.services
                }
            )



-- view


view : Model -> Html msg
view model =
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
                , tbody [ classes "lucida" ] (List.map Nodes.NodeRow.view model)
                ]
            ]
        ]
