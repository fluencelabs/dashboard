module Modules.Interface exposing (..)

import Html exposing (Html, div, span, text)
import Palette exposing (classes)
import String.Interpolate exposing (interpolate)


type alias Signature =
    { arguments : List (List String)
    , name : String
    , output_types : List String
    }


type alias Field =
    { name : String
    , ty : String
    }


type alias Record =
    { fields : List Field
    , id : Int
    , name : String
    }


type alias Interface =
    { function_signatures : List Signature
    , record_types : List Record
    }


type alias Service =
    { id : String
    , blueprint_id : String
    , owner_id : String
    , interface : Maybe Interface
    }


setInterface : Interface -> Service -> Service
setInterface interface service =
    { service | interface = Just interface }


interfaceView : Interface -> List (Html msg)
interfaceView interface =
    recordsView interface.record_types ++ signaturesView interface.function_signatures


recordsView : List Record -> List (Html msg)
recordsView record =
    record |> List.sortBy .name |> List.map recordView


recordView : Record -> Html msg
recordView record =
    div [ classes "i f6" ]
        ([ span [ classes "fl w-100 mt2" ] [ text (record.name ++ " {") ] ]
            ++ fieldsView record.fields
            ++ [ span [ classes "fl w-100 mb2" ] [ text "}" ] ]
        )


fieldsView : List Field -> List (Html msg)
fieldsView fields =
    fields |> List.map (\f -> span [ classes "fl w-100 ml2" ] [ text (String.join ": " [ f.name, f.ty ]) ])


signaturesView : List Signature -> List (Html msg)
signaturesView signatures =
    signatures |> List.sortBy .name |> List.map signatureView


signatureView : Signature -> Html msg
signatureView signature =
    div [ classes "i f6 fl w-100 mv2" ]
        [ text "fn "
        , span [ classes "fw5" ] [ text signature.name ]
        , text (interpolate "({0}) -> {1}" [ argumentsToString signature.arguments, outputToString signature.output_types ])
        ]


argumentsToString : List (List String) -> String
argumentsToString arguments =
    String.join ", " (arguments |> List.map (String.join ": "))


outputToString : List String -> String
outputToString output =
    output |> List.head |> Maybe.withDefault "void"
