module BlueprintPage.View exposing (..)

import BlueprintPage.Model exposing (BlueprintViewInfo)
import Blueprints.Model exposing (Blueprint)
import Dict exposing (Dict)
import Html exposing (Html, article, div, span, text)
import Html.Events exposing (onClick)
import Interface.View exposing (instanceView)
import Model exposing (Model)
import Modules.Model exposing (Module)
import Msg exposing (Msg(..))
import Palette exposing (classes)
import Service.Model exposing (Interface)


view : Model -> String -> Html Msg
view model id =
    let
        blueprintInfo =
            blueprintToInfo model id
    in
    case blueprintInfo of
        Just mi ->
            div [ classes "cf ph2-ns" ]
                [ span [ classes "fl w-100 f1 lh-title dark-red" ] [ text ("Blueprint: " ++ mi.name) ]
                , span [ classes "fl w-100 light-red" ] [ text mi.id ]
                , viewInfo mi
                ]

        Nothing ->
            div [ classes "cf ph2-ns" ]
                [ span [ classes "fl w-100 f1 lh-title dark-red" ] [ text "Module not found" ]
                ]


blueprintToInfo : Model -> String -> Maybe BlueprintViewInfo
blueprintToInfo model id =
        case (Dict.get id model.blueprints) of
            Just bp ->
                let
                    modules = bp.dependencies |> List.map (\d -> Dict.get d model.modules) |> List.filterMap identity
                in
                    Just { name = bp.name
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
        checkToggle = (\id -> blueprintInfo.openedModule |> Maybe.map (\om -> om == id) |> Maybe.withDefault False)
    in
        article [ classes "cf" ]
            [ div [ classes "fl w-30 gray mv1" ] [ text "AUTHOR" ]
            , div [ classes "fl w-70 mv1" ]
                [ span [ classes "fl w-100 black b" ] [ text blueprintInfo.author ]
                , span [ classes "fl w-100 black" ] [ text blueprintInfo.authorPeerId ] ]
            , div [ classes "fl w-30 gray mv1" ] [ text "DESCRIPTION" ]
            , div [ classes "fl w-70 mv1" ] [ span [ classes "fl w-100 black" ] [ text blueprintInfo.description ] ]
            , div [ classes "fl w-30 gray mv1" ] [ text "INTERFACE" ]
            , div [ classes "fl w-70 mv1" ]
                (blueprintInfo.modules |>
                    List.map (\m -> viewToggledInterface (checkToggle m.name) m.name m.interface))
            ]


viewToggledInterface : Bool  -> String -> Interface -> Html Msg
viewToggledInterface isOpen name interface =
    let
        interfaceView = if (isOpen) then [(div [classes "fl w-100 ph4"] (instanceView interface))] else []
    in
        div []
        ([ div [classes "fl w-100 bg-near-white pa2", onClick (ToggleInterface name)] [text name] ]
        ++ interfaceView)


