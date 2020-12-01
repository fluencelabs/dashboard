module ModulePage.View exposing (..)

import Dict exposing (Dict)
import Html exposing (Html, article, div, span, text)
import Interface.View exposing (instanceView)
import Model exposing (Model)
import ModulePage.Model exposing (ModuleViewInfo)
import Modules.Model exposing (Module)
import Palette exposing (classes)


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
        , div [ classes "fl w-70 mv1" ] [ span [ classes "fl w-100 black" ] (instanceView moduleInfo.moduleInfo.interface) ]
        ]
