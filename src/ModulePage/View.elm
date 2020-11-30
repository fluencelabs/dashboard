module ModulePage.View exposing (..)

import Html exposing (Html, article, div, span, text)
import ModulePage.Model exposing (ModuleInfo)
import Palette exposing (classes)
import Services.Model exposing (Record, Signature)
import String.Interpolate exposing (interpolate)


view : ModuleInfo -> Html msg
view moduleInfo =
    div [ classes "cf ph2-ns" ]
        [ span [ classes "fl w-100 f1 lh-title dark-red" ] [ text ("Module: " ++ moduleInfo.name) ]
        , span [ classes "fl w-100 light-red" ] [ text moduleInfo.id ]
        , viewInfo moduleInfo
        ]


viewInfo : ModuleInfo -> Html msg
viewInfo moduleInfo =
    article [ classes "cf" ]
        [ div [ classes "fl w-30 gray mv1" ] [ text "AUTHOR" ]
        , div [ classes "fl w-70 mv1" ] [ span [ classes "fl w-100 black b" ] [ text moduleInfo.author ], span [ classes "fl w-100 black" ] [ text moduleInfo.authorPeerId ] ]
        , div [ classes "fl w-30 gray mv1" ] [ text "DESCRIPTION" ]
        , div [ classes "fl w-70 mv1" ] [ span [ classes "fl w-100 black" ] [ text moduleInfo.description ] ]
        , div [ classes "fl w-30 gray mv1" ] [ text "INTERFACE" ]
        , div [ classes "fl w-70 mv1" ] [ span [ classes "fl w-100 black" ] (recordsView moduleInfo.service.interface.record_types ++ signaturesView moduleInfo.service.interface.function_signatures) ]
        ]


recordsView : List Record -> List (Html msg)
recordsView record =
    List.map recordView record


recordView : Record -> Html msg
recordView record =
    div [ classes "i" ]
        ([ span [ classes "fl w-100 mt2" ] [ text (record.name ++ " {") ] ]
            ++ fieldsView record.fields
            ++ [ span [ classes "fl w-100 mb2" ] [ text "}" ] ]
        )


fieldsView : List (List String) -> List (Html msg)
fieldsView fields =
    fields |> List.map (\f -> span [ classes "fl w-100 ml2" ] [ text (String.join ": " f) ])


signaturesView : List Signature -> List (Html msg)
signaturesView signatures =
    List.map signatureView signatures


signatureView : Signature -> Html msg
signatureView signature =
    div [ classes "i fl w-100 mv2" ]
        [ text (interpolate "fn {0}({1}) -> {2}" [ signature.name, argumentsToString signature.arguments, outputToString signature.output_types ]) ]


argumentsToString : List (List String) -> String
argumentsToString arguments =
    String.join ", " (arguments |> List.map (String.join ": "))


outputToString : List String -> String
outputToString output =
    output |> List.head |> Maybe.withDefault "void"
