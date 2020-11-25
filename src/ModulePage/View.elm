module ModulePage.View exposing (..)

import Html exposing (Html)
import ModulePage.Model exposing (ModuleInfo)
import Palette exposing (classes)

view : ModuleInfo -> Html msg
view moduleInfo =
    Html.div [classes "cf ph2-ns"]
    [ Html.span [classes "fl w-100 f1 lh-title dark-red"] [Html.text ("Module: " ++ moduleInfo.name)]
    , Html.span [classes "fl w-100 light-red"] [Html.text (moduleInfo.id)]
    , viewInfo moduleInfo
    ]

viewInfo : ModuleInfo -> Html msg
viewInfo moduleInfo =
    Html.article [classes "cf"]
    [ Html.div [classes "fl w-30 gray"] [Html.text "AUTHOR"]
    , Html.div [classes "fl w-70"] [ Html.span [classes "fl w-100 black b"] [Html.text moduleInfo.author], Html.span [classes "fl w-100 black"] [Html.text moduleInfo.authorPeerId]]
    , Html.div [classes "fl w-30 gray"] [Html.text "DESCRIPTION"]
    , Html.div [classes "fl w-70"] [ Html.span [classes "fl w-100 black b"] [Html.text moduleInfo.author]]
    ]
