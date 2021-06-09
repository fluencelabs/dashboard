module SpinnerView exposing (..)

import Html exposing (Html)
import Html.Attributes exposing (height, width)
import Model exposing (Model)
import Palette exposing (classes)


spinner : Model -> List (Html msg)
spinner model =
    [ Html.div [ classes "p3 relative" ]
        [ Html.div [ classes "spin" ] [] ]
    ]
