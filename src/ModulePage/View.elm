module ModulePage.View exposing (..)

import Html exposing (Html)
import Json.Encode as Encode
import ModulePage.Model exposing (ModuleInfo)
import Palette exposing (classes)
import Services.Model exposing (Record, Signature)
import String.Interpolate exposing (interpolate)


view : ModuleInfo -> Html msg
view moduleInfo =
    Html.div [ classes "cf ph2-ns" ]
        [ Html.span [ classes "fl w-100 f1 lh-title dark-red" ] [ Html.text ("Module: " ++ moduleInfo.name) ]
        , Html.span [ classes "fl w-100 light-red" ] [ Html.text moduleInfo.id ]
        , viewInfo moduleInfo
        ]


viewInfo : ModuleInfo -> Html msg
viewInfo moduleInfo =
    Html.article [ classes "cf" ]
        [ Html.div [ classes "fl w-30 gray mv1" ] [ Html.text "AUTHOR" ]
        , Html.div [ classes "fl w-70 mv1" ] [ Html.span [ classes "fl w-100 black b" ] [ Html.text moduleInfo.author ], Html.span [ classes "fl w-100 black" ] [ Html.text moduleInfo.authorPeerId ] ]
        , Html.div [ classes "fl w-30 gray mv1" ] [ Html.text "DESCRIPTION" ]
        , Html.div [ classes "fl w-70 mv1" ] [ Html.span [ classes "fl w-100 black" ] [ Html.text moduleInfo.description ] ]
        , Html.div [ classes "fl w-30 gray mv1" ] [ Html.text "INTERFACE" ]
        , Html.div [ classes "fl w-70 mv1" ] [ Html.span [ classes "fl w-100 black" ] (recordsView moduleInfo.service.interface.record_types ++ signaturesView moduleInfo.service.interface.function_signatures) ]
        ]


recordsView : List Record -> List (Html msg)
recordsView record =
    List.map recordView record


recordView : Record -> Html msg
recordView record =
    Html.div [ classes "i" ]
        ([ Html.span [ classes "fl w-100 mt2" ] [ Html.text (record.name ++ " {") ] ]
            ++ fieldsView record.fields
            ++ [ Html.span [ classes "fl w-100 mb2" ] [ Html.text "}" ] ]
        )


fieldsView : List (List String) -> List (Html msg)
fieldsView fields =
    fields |> List.map (\f -> Html.span [ classes "fl w-100 ml2" ] [ Html.text (String.join ": " f) ])


signaturesView : List Signature -> List (Html msg)
signaturesView signatures =
    List.map signatureView signatures


signatureView : Signature -> Html msg
signatureView signature =
    Html.div [ classes "i fl w-100 mv2" ]
        [ Html.text (interpolate "fn {0}({1}) -> {2}" [ signature.name, argumentsToString signature.arguments, outputToString signature.output_types ]) ]


argumentsToString : List (List String) -> String
argumentsToString arguments =
    String.join ", " (arguments |> List.map (String.join ": "))


outputToString : List String -> String
outputToString output =
    output |> List.head |> Maybe.withDefault "void"
