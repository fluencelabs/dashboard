module Pages.NodesPage exposing (Model, fromCache, init, view)

import Cache
import Html exposing (..)
import Nodes.NodesTable
import Palette exposing (..)



-- model


type alias Model =
    Nodes.NodesTable.Model


fromCache : Cache.Model -> Model
fromCache cache =
    Nodes.NodesTable.fromCache cache


init : Model
init =
    []



-- view


view : Model -> Html msg
view model =
    div [ classes "fl w-100 cf ph2-ns" ]
        [ div [ classes "fl w-100 mb2 pt4 pb4" ]
            [ div [ redFont, classes "f1 fw4 pt3" ] [ text "Network Nodes" ]
            ]
        , div [ classes "fl w-100 mt2 mb4 bg-white br3" ] [ Nodes.NodesTable.view model ]
        ]
