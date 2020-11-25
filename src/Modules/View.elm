module Modules.View exposing (..)

import Html exposing (Html)
import Modules.Model exposing (Model, ModuleInfo)
import Palette exposing (classes)
import Utils.Utils exposing (instancesText)


view : Model -> Html msg
view model =
    let
        modulesView =
            List.map viewService model.modules
    in
    Html.div [ classes "cf ph2-ns" ] modulesView


viewService : ModuleInfo -> Html msg
viewService service =
    Html.div [ classes "fl w-third-ns pa2" ]
        [ Html.div [ classes "fl w-100 br2 ba solid pa2 mh2" ]
            [ Html.p [ classes "tl di" ] [ Html.span [ classes "b pl2" ] [ Html.text service.name ], Html.span [ classes "di fr pr2" ] [ instancesText service.instanceNumber ] ]
            ]
        ]
