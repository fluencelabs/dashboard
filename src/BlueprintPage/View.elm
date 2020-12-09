module BlueprintPage.View exposing (..)

import BlueprintPage.Model exposing (BlueprintViewInfo)
import Blueprints.Model exposing (Blueprint)
import Dict exposing (Dict)
import Html exposing (Html, article, div, span, text)
import Html.Events exposing (onClick)
import Instances.View
import Interface.View exposing (interfaceView)
import Model exposing (Model)
import Modules.Model exposing (Module)
import Msg exposing (Msg(..))
import Palette exposing (classes, darkRed, redFont)
import Service.Model exposing (Interface)


view : Model -> String -> Html Msg
view model id =
    let
        blueprintInfo =
            blueprintToInfo model id
    in
    case blueprintInfo of
        Just bi ->
            let
                ( instanceNum, instanceView ) =
                    Instances.View.view model (\service -> service.blueprint_id == id)
            in
            div [ classes "fl w-100" ]
                [ div [ classes "fl w-100 pb4 pt4" ]
                    [ div [ redFont, classes "f1 fw4 pt3 pb2" ] [ text ("Blueprint: " ++ bi.name) ]
                    , span [ classes "fl w-100", darkRed ] [ text bi.id ]
                    ]
                , div [ classes "fl w-100 bg-white mt2 ph4 pt3 mb5 pb3 br3" ] [ viewInfo bi ]
                , div [ classes "pt4 fw5 f3 pb4" ] [ text ("Instances (" ++ String.fromInt instanceNum ++ ")") ]
                , div [ classes "fl w-100 mt2 mb4 bg-white br3" ]
                    [ instanceView ]
                ]

        Nothing ->
            div [ classes "cf ph2-ns" ]
                []


blueprintToInfo : Model -> String -> Maybe BlueprintViewInfo
blueprintToInfo model id =
    case Dict.get id model.blueprints of
        Just bp ->
            let
                modules =
                    bp.dependencies |> List.map (\d -> Dict.get d model.modules) |> List.filterMap identity
            in
            Just
                { name = bp.name
                , id = id
                , author = "Fluence Labs"
                , authorPeerId = "fluence_labs_peer_id"
                , description = "Excelent blueprint"
                , website = "https://github.com/fluencelabs/"
                , blueprint = bp
                , modules = modules
                , openedModule = model.toggledInterface
                }

        Nothing ->
            Nothing


viewInfo : BlueprintViewInfo -> Html Msg
viewInfo blueprintInfo =
    let
        checkToggle =
            \id -> blueprintInfo.openedModule |> Maybe.map (\om -> om == id) |> Maybe.withDefault False
    in
    article [ classes "cf" ]
        [ div [ classes "fl w-100 w-20-ns gray-font mv3" ] [ text "AUTHOR" ]
        , div [ classes "fl w-100 w-80-ns mv3 lucida" ]
            [ span [ classes "fl w-100 black b" ] [ text blueprintInfo.author ] ]
        , div [ classes "fl w-100 w-20-ns gray-font mv3" ] [ text "DESCRIPTION" ]
        , div [ classes "fl w-100 w-80-ns mv3" ] [ span [ classes "fl w-100 black lucida pv1" ] [ text blueprintInfo.description ] ]
        , div [ classes "fl w-100 w-20-ns gray-font mv3" ] [ text "INTERFACE" ]
        , div [ classes "fl w-100 w-80-ns mv3" ]
            (blueprintInfo.modules
                |> List.map (\m -> viewToggledInterface (checkToggle m.name) m.name m.interface)
            )
        ]


viewToggledInterface : Bool -> String -> Interface -> Html Msg
viewToggledInterface isOpen name interface =
    let
        interfaceViewEl =
            if isOpen then
                [ div [ classes "fl w-100 ph3" ] (interfaceView interface) ]

            else
                []
    in
    div []
        ([ div [ classes "fl w-100 light-shadow bg-near-white pa2 mv2 pointer", onClick (ToggleInterface name) ]
            [ span [ classes "fl mh2 pv1 tl" ] [ text name ]
            , div [ classes "o-40 f4 tr pr3" ]
                [ if isOpen then
                    text "▲"

                  else
                    text "▼"
                ]
            ]
         ]
            ++ interfaceViewEl
        )
