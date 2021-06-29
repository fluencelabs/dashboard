module Blueprints.BlueprintTile exposing (Model, view)

import Html exposing (Html, a, div, span, text)
import Html.Attributes exposing (attribute)
import Palette exposing (classes)



-- Model


type alias Model =
    { name : String
    , author : String
    , numberOfInstances : Int
    , id : String
    }



-- View


view : Model -> Html msg
view model =
    div [ classes "fl w-100 w-third-ns pr3 lucida" ]
        [ a
            [ attribute "href" ("/blueprint/" ++ model.id)
            , classes "fl w-100 bg-white black mw6 mr3 mb3 hide-child pv3 pl4 br3 element-box ba b--white no-underline"
            ]
            [ div [ classes "w-100 mb3 pt1 b f3 overflow-hidden" ] [ text model.name ]
            , div [ classes "w-100 mb4 fw4 gray-font" ] [ text "By ", span [ classes "lucida-in normal" ] [ text model.author ] ]
            , div [ classes "w-100 mt1 lucida gray-font" ] [ servicesText model.numberOfInstances ]
            ]
        ]


servicesText : Int -> Html msg
servicesText num =
    let
        strNum =
            String.fromInt num
    in
    if num == 1 then
        Html.text (strNum ++ " service")

    else
        Html.text (strNum ++ " services")
