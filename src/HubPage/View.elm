module HubPage.View exposing (..)

import Html exposing (Html, a, div, h1, h3, span, text)
import Html.Attributes exposing (attribute)
import Instances.View
import Model exposing (Model)
import Modules.View
import Palette exposing (classes, redFont)
import Services.View


view : Model -> Html msg
view model =
    div []
        [ h1 [ redFont ] [ text "Developer Hub" ]
        , welcomeText
        , h3 [] [ text "Featured Services" ]
        , Services.View.view model
        , h3 [] [ text "Featured Modules" ]
        , Modules.View.view model
        , h3 [] [ text "Service Instances" ]
        , Instances.View.view model
        ]


welcomeText : Html msg
welcomeText =
    div [ classes "w-two-thirds" ]
        [ span []
            [ text "Welcome to the Fluence Developer Hub! Start building with composing existing services or explore featured modules to create your custom services. Learn more about how to build applications in "
            , a [ attribute "href" "/" ] [ text "Documentation" ]
            , text " and "
            , a [ attribute "href" "/" ] [ text "Tutorials" ]
            , text "."
            ]
        ]
