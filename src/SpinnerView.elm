module SpinnerView exposing (..)

import Color
import Html exposing (Html)
import Model exposing (Model)
import Palette exposing (classes)
import Spinner


spinner : Model -> List (Html msg)
spinner model =
    [ Html.div [ classes "p3 relative" ]
        [ Spinner.view
            { lines = 11
            , length = 20
            , width = 9
            , radius = 21
            , scale = 0.5
            , corners = 1
            , opacity = 0.25
            , rotate = 0
            , direction = Spinner.Clockwise
            , speed = 1
            , trail = 60
            , translateX = 50
            , translateY = 50
            , shadow = True
            , hwaccel = False
            , color = always <| Color.rgba 255 255 255 1
            }
            model.spinner
        ]
    ]
