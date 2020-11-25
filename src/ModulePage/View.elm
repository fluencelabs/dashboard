module ModulePage.View exposing (..)

import Html exposing (Html)
import Json.Encode as Encode
import ModulePage.Model exposing (ModuleInfo)
import Palette exposing (classes)
import Services.Model exposing (Record)
import String.Interpolate exposing(interpolate)

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
    [ Html.div [classes "fl w-30 gray mv1"] [Html.text "AUTHOR"]
    , Html.div [classes "fl w-70 mv1"] [ Html.span [classes "fl w-100 black b"] [Html.text moduleInfo.author], Html.span [classes "fl w-100 black"] [Html.text moduleInfo.authorPeerId]]
    , Html.div [classes "fl w-30 gray mv1"] [Html.text "DESCRIPTION"]
    , Html.div [classes "fl w-70 mv1"] [ Html.span [classes "fl w-100 black"] [Html.text moduleInfo.description]]
    , Html.div [classes "fl w-30 gray mv1"] [Html.text "INTERFACE"]
    , Html.div [classes "fl w-70 mv1"] [ Html.span [classes "fl w-100 black"] (recordsToString moduleInfo.service.interface.record_types)]
    ]

recordsToString : List Record -> List (Html msg)
recordsToString record =
    (List.map recordToString record)

recordToString : Record -> Html msg
recordToString record =
    Html.div [classes "i"]
    ([Html.span [classes "fl w-100 mt2"] [Html.text (record.name ++ " {")]] ++
    fieldsToString record.fields ++
    [Html.span [classes "fl w-100 mb2"] [Html.text ("}")]])


fieldsToString : List (List String) -> List (Html msg)
fieldsToString fields =
    (fields |> List.map (\f -> Html.span [classes "fl w-100 ml2"] [Html.text (String.join ": " f)] ))

