module HubPage.View exposing (..)

import Blueprints.View
import Html exposing (Html, a, div, h1, h3, span, text)
import Html.Attributes exposing (attribute, style)
import Instances.View
import Model exposing (Model)
import Modules.View
import Palette exposing (classes, redFont)


view : Model -> Html msg
view model =
    div []
        [ h1 [ redFont, classes "f2 lh-copy" ] [ text "Developer Hub" ]
        , welcomeText
        , h3 [ classes "mt4 pt4 mb4 medium-roboto" ] [ text "Featured Blueprints" ]
        , Blueprints.View.view model
        , h3 [ classes "mt3 pt3 mb4 medium-roboto" ] [ text "Featured Modules" ]
        , Modules.View.view model
        , h3 [ classes "mt3 pt3 mb4 medium-roboto" ] [ text "Service Instances" ]
        , Tuple.second (Instances.View.view model (\_ -> True))
        ]


welcomeText : Html msg
welcomeText =
    div [ classes "w-two-thirds lucida welcome-text" ]
        [ span []
            [ text "Welcome to the Fluence Developer Hub! Start building with composing existing services or explore featured modules to create your custom services. Learn more about how to build applications in "
            , a [ attribute "href" "https://fluence-labs.readme.io/docs" ] [ text "Documentation" ]
            --, text " and "
            --, a [ attribute "href" "/" ] [ text "Tutorials" ]
            , text "."
            ]
        ]
