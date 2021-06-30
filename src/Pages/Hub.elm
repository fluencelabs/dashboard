module Pages.Hub exposing (Model, fromCache, init, view)

import Blueprints.BlueprintsList
import Cache
import Html exposing (Html, a, div, span, text)
import Html.Attributes exposing (attribute)
import Palette exposing (classes, redFont)



-- model


type alias FmModel =
    {}


type alias ServicesModel =
    {}


type alias Model =
    { featuredBlueprints : Blueprints.BlueprintsList.Model
    , featuredModules : FmModel
    , services : ServicesModel
    }


init : Model
init =
    { featuredBlueprints = []
    , featuredModules = {}
    , services = {}
    }


fromCache : Cache.Model -> Model
fromCache cache =
    { featuredBlueprints = Blueprints.BlueprintsList.fromCache cache
    , featuredModules = {}
    , services = {}
    }



-- view


view : Model -> Html msg
view model =
    div [ classes "fl w-100 pt4" ]
        [ div [ redFont, classes "f1 fw4 pt3 pb3" ] [ text "Developer Hub" ]
        , welcomeText
        , div [ classes "pt4 f3 fw5 pb4" ] [ text "Featured Service Blueprints" ]
        , Blueprints.BlueprintsList.view model.featuredBlueprints
        , div [ classes "pt4 f3 fw5 pb4" ] [ text "Featured Modules" ]

        --, Modules.View.view model
        , div [ classes "pt4 f3 fw5 pb4" ] [ text "Services" ]

        --, Tuple.second (Instances.View.view model (\_ -> True))
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
