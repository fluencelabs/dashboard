module HubPage.View exposing (..)

import Html exposing (Html)
import Instances.View
import Model exposing (Model)
import Modules.View
import Services.View


view : Model -> Html msg
view model =
    Html.div []
        [ Services.View.view model
        , Modules.View.view model
        , Instances.View.view model
        ]
