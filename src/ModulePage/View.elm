module ModulePage.View exposing (..)

import Dict exposing (Dict)
import Html exposing (Html, article, div, span, text)
import Model exposing (Model)
import ModulePage.Model exposing (ModuleViewInfo)
import Modules.Model exposing (Module)
import Palette exposing (classes)
import Services.Model exposing (Record, Signature)
import String.Interpolate exposing (interpolate)


view : Model -> String -> Html msg
view model id =
    let
        moduleInfo =
            modelToServiceInfo model.modules id
    in
    case moduleInfo of
        Just mi ->
            div [ classes "cf ph2-ns" ]
                [ span [ classes "fl w-100 f1 lh-title dark-red" ] [ text ("Module: " ++ mi.name) ]
                , span [ classes "fl w-100 light-red" ] [ text mi.id ]
                , viewInfo mi
                ]

        Nothing ->
            div [ classes "cf ph2-ns" ]
                [ span [ classes "fl w-100 f1 lh-title dark-red" ] [ text "Module not found" ]
                ]


modelToServiceInfo : Dict String Module -> String -> Maybe ModuleViewInfo
modelToServiceInfo modules id =
    let
        moduleInfo =
            Dict.get id modules

        name =
            moduleInfo |> Maybe.map .name |> Maybe.withDefault "unknown"

        info =
            moduleInfo
                |> Maybe.map
                    (\m ->
                        { name = name
                        , id = id
                        , author = "Fluence Labs"
                        , authorPeerId = "fluence_labs_peer_id"
                        , description = "Excelent module"
                        , website = "https://github.com/fluencelabs/"
                        , moduleInfo = m
                        }
                    )
    in
    info


viewInfo : ModuleViewInfo -> Html msg
viewInfo moduleInfo =
    article [ classes "cf" ]
        [ div [ classes "fl w-30 gray mv1" ] [ text "AUTHOR" ]
        , div [ classes "fl w-70 mv1" ] [ span [ classes "fl w-100 black b" ] [ text moduleInfo.author ], span [ classes "fl w-100 black" ] [ text moduleInfo.authorPeerId ] ]
        , div [ classes "fl w-30 gray mv1" ] [ text "DESCRIPTION" ]
        , div [ classes "fl w-70 mv1" ] [ span [ classes "fl w-100 black" ] [ text moduleInfo.description ] ]
        , div [ classes "fl w-30 gray mv1" ] [ text "INTERFACE" ]
        , div [ classes "fl w-70 mv1" ] [ span [ classes "fl w-100 black" ] (recordsView moduleInfo.moduleInfo.interface.record_types ++ signaturesView moduleInfo.moduleInfo.interface.function_signatures) ]
        ]


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
