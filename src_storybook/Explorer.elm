module Explorer exposing (main)

import Blueprints.BlueprintTile
import Html exposing (div)
import Html.Attributes exposing (attribute, style)
import HubPage.View exposing (welcomeText)
import UIExplorer
    exposing
        ( UIExplorerProgram
        , category
        , createCategories
        , defaultConfig
        , explore
        , exploreWithCategories
        , storiesOf
        )


config =
    defaultConfig


main : UIExplorerProgram {} () {} {}
main =
    exploreWithCategories
        config
        (createCategories
            |> category
                "Hub"
                [ storiesOf
                    "Welcome"
                    [ ( "default", \_ -> welcomeText, {} ) ]
                , storiesOf
                    "Modules"
                    [ ( "1", \_ -> welcomeText, {} ) ]
                ]
            |> category
                "Blueprints"
                [ storiesOf
                    "Tile"
                    [ let
                        model =
                            { name = "String"
                            , author = "String"
                            , numberOfInstances = 10
                            , id = "String"
                            }
                      in
                      ( "Blueprint tile", \_ -> wrapper {} (Blueprints.BlueprintTile.view model), {} )
                    ]
                ]
        )


wrapper opts x =
    div
        [ style "height" "500px"
        , style "width" "500px"
        , style "background" "#F4F4F4"
        , style "padding" "50px"
        ]
        [ x ]
