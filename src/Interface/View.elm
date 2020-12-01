module Interface.View exposing (..)

import Html exposing (Html, div, span, text)
import Palette exposing (classes)
import Service.Model exposing (Interface, Record, Signature)
import String.Interpolate exposing (interpolate)


instanceView : Interface -> List (Html msg)
instanceView interface =
    recordsView interface.record_types ++ signaturesView interface.function_signatures


recordsView : List Record -> List (Html msg)
recordsView record =
    record |> List.sortBy .name |> List.map recordView


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
    signatures |> List.sortBy .name |> List.map signatureView


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
