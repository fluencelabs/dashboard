module Modules.Interface exposing (Model, view)

import Html exposing (Html, div, pre, span, text)
import Palette exposing (classes)
import String.Extra as String
import String.Interpolate exposing (interpolate)



-- model


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


type alias Model =
    { function_signatures : List Signature
    , record_types : List Record
    , name : String
    }



-- view


view : Model -> Html msg
view model =
    pre [ classes "i f6 ma0" ] [ text <| interfaceView model ]


tab : String
tab =
    "    "


interfaceView : Model -> String
interfaceView model =
    recordsView model.record_types ++ "\n\n" ++ signaturesView model


recordsView : List Record -> String
recordsView records =
    String.join "\n\n" (List.map recordView records)


recordView : Record -> String
recordView record =
    "data "
        ++ record.name
        ++ ":\n"
        ++ fieldsView record.fields


fieldsView : List Field -> String
fieldsView fields =
    String.join "\n" (List.map (\x -> tab ++ String.join ": " [ x.name, x.ty ]) fields)


signaturesView : Model -> String
signaturesView model =
    "service "
        ++ String.toTitleCase model.name
        ++ ":\n"
        ++ String.join "\n" (List.map signatureView model.function_signatures)


signatureView : Signature -> String
signatureView signature =
    tab
        ++ signature.name
        ++ interpolate "({0}) -> {1}" [ argumentsToString signature.arguments, outputToString signature.output_types ]


argumentsToString : List (List String) -> String
argumentsToString arguments =
    String.join ", " (arguments |> List.map (String.join ": "))


outputToString : List String -> String
outputToString output =
    output |> List.head |> Maybe.withDefault "void"
