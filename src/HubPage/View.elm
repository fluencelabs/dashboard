module HubPage.View exposing (..)

import Blueprints.View
import Html exposing (Html, a, div, span, text)
import Html.Attributes exposing (attribute)
import Instances.View
import Model exposing (Model)
import Modules.View
import Palette exposing (classes, redFont)


view : Model -> Html msg
view model =
    div [ classes "pt4" ]
        [ div [ redFont, classes "f1 fw4 pt3 pb3" ] [ text "Developer Hub" ]
        , welcomeText
        , div [ classes "pt4 f3 fw5 pb4" ] [ text "Featured Blueprints" ]
        , Blueprints.View.view model
        , div [ classes "pt4 f3 fw5 pb4" ] [ text "Featured Modules" ]
        , Modules.View.view model
        , div [ classes "pt4 f3 fw5 pb4" ] [ text "Blueprint Instances" ]
        , Tuple.second (Instances.View.view model (\_ -> True))
        ]


welcomeText : Html msg
welcomeText =
    div [ classes "w-two-thirds-ns lucida welcome-text pt2 pb3" ]
        [ span []
            [ text "Welcome to the Fluence Developer Hub! Start building with composing existing services or explore featured modules to create your custom services. Learn more about how to build applications in "
            , a [ attribute "href" "https://fluence-labs.readme.io/docs" ] [ text "Documentation" ]
            --, text " and "
            --, a [ attribute "href" "/" ] [ text "Tutorials" ]
            , text "."
            ]
        ]
