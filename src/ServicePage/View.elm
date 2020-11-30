module ServicePage.View exposing (..)

import Dict
import Html exposing (Html, article, div, span, text)
import List.Extra
import Model exposing (Model)
import Palette exposing (classes)
import ServicePage.Model exposing (ServiceInfo)
import Services.Model exposing (Record, Signature)
import String.Interpolate exposing (interpolate)


view : Model -> String -> Html msg
view model id =
    let
        moduleInfo =
            modelToServiceInfo model id
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


modelToServiceInfo : Model -> String -> Maybe ServiceInfo
modelToServiceInfo model id =
    let
        datas =
            Dict.toList model.discoveredPeers

        services =
            datas |> List.map (\( peer, data ) -> data.services |> List.map (\s -> ( peer, s ))) |> List.concat

        blueprints =
            datas |> List.map (\( _, data ) -> data.blueprints) |> List.concat |> List.map (\bp -> ( bp.id, bp.name )) |> Dict.fromList

        service =
            services |> List.Extra.find (\( _, s ) -> s.service_id == id)

        name =
            service |> Maybe.andThen (\( _, s ) -> blueprints |> Dict.get s.blueprint_id) |> Maybe.withDefault "unknown"

        info =
            service
                |> Maybe.map
                    (\( p, s ) ->
                        { name = name
                        , id = id
                        , author = "Fluence Labs"
                        , authorPeerId = p
                        , description = "Cool service"
                        , website = "https://github.com/fluencelabs/chat"
                        , service = s
                        }
                    )
    in
    info


viewInfo : ServiceInfo -> Html msg
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
