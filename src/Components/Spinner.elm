module Components.Spinner exposing (..)

import Html exposing (Html, div)
import Utils.Html exposing (classes)



-- view


view : List (Html msg)
view =
    [ div [ classes "p3 relative" ]
        [ div [ classes "spin" ] [] ]
    ]
