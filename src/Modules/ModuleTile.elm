module Modules.ModuleTile exposing (Model, view)

import Html exposing (Html, a, div, p, text)
import Html.Attributes exposing (attribute)
import Palette exposing (classes)



-- model


type alias Model =
    { hash : String
    , name : String
    , numberOfUsages : Int
    }



-- view


view : Model -> Html msg
view model =
    let
        usages =
            [ text <| String.fromInt model.numberOfUsages ++ " instance(s)" ]
    in
    div [ classes "fl w-100 w-third-ns pr3" ]
        [ a
            [ attribute "href" ("/module/" ++ model.name)
            , classes "fl w-100 bg-white black mw6 mr2 mb3 hide-child pa2 element-box ba b--white pl3"
            ]
            [ p [ classes "tl di" ]
                [ div [ classes "fl b w-100 mb1 fw5 overflow-hidden" ]
                    [ text model.name ]
                , div [ classes "fl w-100 mt1 lucida gray-font2" ] usages
                ]
            ]
        ]
