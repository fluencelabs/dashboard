module Services.View exposing (..)

import Html exposing (Html)
import Palette exposing (classes)
import Services.Model exposing (Model, ServiceInfo)
import Utils.Utils exposing (instancesText)


view : Model -> Html msg
view model =
    let
        servicesView =
            List.map viewService model.services
    in
    Html.div [ classes "cf ph2-ns" ] servicesView


viewService : ServiceInfo -> Html msg
viewService service =
    Html.div [ classes "fl w-third-ns pa2" ]
        [ Html.div [ classes "fl w-100 br2 ba solid ma2 pa3" ]
            [ Html.div [ classes "w-100 mb2 b" ] [ Html.text service.name ]
            , Html.div [ classes "w-100 mb4" ] [ Html.text ("By " ++ service.author) ]
            , Html.div [ classes "w-100" ] [ instancesText service.instanceNumber ]
            ]
        ]
