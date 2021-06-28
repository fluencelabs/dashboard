module Explorer exposing (main)

import Html
import HubPage.View exposing (welcomeText)
import UIExplorer
    exposing
        ( UIExplorerProgram
        , defaultConfig
        , explore
        , storiesOf
        )


main : UIExplorerProgram {} () {} {}
main =
    explore
        defaultConfig
        [ storiesOf
            "Welcome"
            [ ( "Default", \_ -> Html.text "Welcome to you explorer.", {} )
            ]
        , storiesOf
            "HubView"
            [ ( "1", \_ -> welcomeText, {} ) ]
        ]
