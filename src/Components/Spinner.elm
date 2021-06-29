module Components.Spinner exposing (..)

import Html exposing (Html, div)
import Palette exposing (classes)


spinner : List (Html msg)
spinner =
    [ div [ classes "p3 relative" ]
        [ div [ classes "spin" ] [] ]
    ]
