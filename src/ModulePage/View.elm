module ModulePage.View exposing (..)

import Dict exposing (Dict)
import Html exposing (Html, article, div, h3, span, text)
import Instances.View
import Interface.View exposing (interfaceView)
import Model exposing (Model)
import ModulePage.Model exposing (ModuleViewInfo)
import Modules.Model exposing (Module)
import Palette exposing (classes)


view : Model -> String -> Html msg
view model id =
    let
        moduleInfo =
            moduleToInfo model.modules id
    in
    case moduleInfo of
        Just mi ->
            let
                check =
                    Maybe.map (\bp -> bp.dependencies |> List.member id)

                filter =
                    \s -> model.blueprints |> Dict.get s.blueprint_id |> check |> Maybe.withDefault False

                ( instanceNum, instanceView ) =
                    Instances.View.view model filter
            in
            div [ classes "fl w-100 cf ph2-ns" ]
                [ div [ classes "fl w-100 mb2 pt2" ]
                    [ span [ classes "fl w-100 f1 lh-title dark-red" ] [ text ("Module: " ++ mi.name) ]
                    ]
                , div [ classes "fl w-100 bg-white mt2 mh2 ph4 pt3" ] [ viewInfo mi ]
                , h3 [ classes "pt3" ] [ text ("Instances (" ++ String.fromInt instanceNum ++ ")") ]
                , div [ classes "fl w-100 mt2 bg-white" ] [ instanceView ]
                ]

        Nothing ->
            div [ classes "cf ph2-ns" ]
                [ span [ classes "fl w-100 f1 lh-title dark-red" ] [ text "Module not found" ]
                ]


moduleToInfo : Dict String Module -> String -> Maybe ModuleViewInfo
moduleToInfo modules id =
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
        , div [ classes "fl w-70 mv1" ] [ span [ classes "fl w-100 black" ] (interfaceView moduleInfo.moduleInfo.interface) ]
        ]
