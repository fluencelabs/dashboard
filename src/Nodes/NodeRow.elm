module Nodes.NodeRow exposing (Model, view)

import Cache exposing (PeerId)
import Html exposing (Html, p, td, text, tr)
import Palette exposing (..)



-- model


type alias Model =
    { peerId : PeerId
    , addr : String
    , numberOfServices : Int
    }



-- view


view : Model -> Html msg
view model =
    tr [ classes "table-red-row" ]
        [ td [ classes "ph3" ] [ p [ classes "ws-normal" ] [ text model.peerId ] ]
        , td [ classes "ph3" ] [ p [ classes "ws-normal" ] [ text model.addr ] ]
        , td [ classes "ph3 dn dtc-ns" ] [ p [ classes "ws-normal" ] [ text (String.fromInt model.numberOfServices) ] ]
        ]
