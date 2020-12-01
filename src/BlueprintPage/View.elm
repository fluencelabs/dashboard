module BlueprintPage.View exposing (..)

import BlueprintPage.Model exposing (BlueprintViewInfo)
import Blueprints.Model exposing (Blueprint)
import Dict exposing (Dict)
import Html exposing (Html, article, div, span, text)
import Interface.View exposing (instanceView)
import Model exposing (Model)
import Modules.Model exposing (Module)
import Palette exposing (classes)
import Service.Model exposing (Interface)


view : Model -> String -> Html msg
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
                    }

            Nothing ->
                Nothing



viewInfo : BlueprintViewInfo -> Html msg
viewInfo blueprintInfo =
    article [ classes "cf" ]
        [ div [ classes "fl w-30 gray mv1" ] [ text "AUTHOR" ]
        , div [ classes "fl w-70 mv1" ] [ span [ classes "fl w-100 black b" ] [ text blueprintInfo.author ], span [ classes "fl w-100 black" ] [ text blueprintInfo.authorPeerId ] ]
        , div [ classes "fl w-30 gray mv1" ] [ text "DESCRIPTION" ]
        , div [ classes "fl w-70 mv1" ] [ span [ classes "fl w-100 black" ] [ text blueprintInfo.description ] ]
        , div [ classes "fl w-30 gray mv1" ] [ text "INTERFACE" ]
        , div [ classes "fl w-70 mv1" ] (blueprintInfo.modules |> List.map (\m -> viewToggledInterface True m.name m.interface))
        ]

viewToggledInterface : Bool -> String -> Interface -> Html msg
viewToggledInterface isOpen name interface =
    div []
    ([ text name
        ] ++
        instanceView interface)

