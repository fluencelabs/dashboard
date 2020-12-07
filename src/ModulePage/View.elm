module ModulePage.View exposing (..)

import Dict exposing (Dict)
import Html exposing (Html, a, article, div, h1, h3, span, text)
import Html.Attributes exposing (attribute, style)
import Info exposing (getDescription, getSite)
import Instances.View
import Interface.View exposing (interfaceView)
import Model exposing (Model)
import ModulePage.Model exposing (ModuleViewInfo)
import Modules.Model exposing (Module)
import Palette exposing (classes, redFont)


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
                    [ h1 [ redFont, classes "f2 lh-copy ma0 mt4" ] [ text ("Module: " ++ mi.name) ]
                    ]
                , div [ classes "fl w-100 bg-white mt2 ph4 pt3 mb4 pb2 br3" ] [ viewInfo mi ]
                , h3 [ classes "pt3" ] [ text ("Instances (" ++ String.fromInt instanceNum ++ ")") ]
                , div [ classes "fl w-100 mt2 mb4 bg-white br3" ] [ instanceView ]
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
                        , authorPeerId = ""
                        , description = getDescription m.name
                        , website = getSite m.name
                        , moduleInfo = m
                        }
                    )
    in
    info


viewInfo : ModuleViewInfo -> Html msg
viewInfo moduleInfo =
    article [ classes "cf" ]
        [ div [ style "word-break" "break-all", classes "fl w-100 w-30-ns gray mv1" ] [ text "AUTHOR" ]
        , div [ style "word-break" "break-all", classes "fl w-100 w-70-ns mv1" ] [ span [ classes "fl w-100 black b" ] [ text moduleInfo.author ], span [ classes "fl w-100 black" ] [ text moduleInfo.authorPeerId ] ]
        , div [ style "word-break" "break-all", classes "fl w-100 w-30-ns gray mv1" ] [ text "WEBSITE" ]
        , div [ style "word-break" "break-all", classes "fl w-100 w-70-ns mv1" ] [ a [ attribute "href" moduleInfo.website, classes "fl w-100 black" ] [ text moduleInfo.website ] ]
        , div [ style "word-break" "break-all", classes "fl w-100 w-30-ns gray mv1" ] [ text "DESCRIPTION" ]
        , div [ style "word-break" "break-all", classes "fl w-100 w-70-ns mv1" ] [ span [ classes "fl w-100 black" ] [ text moduleInfo.description ] ]
        , div [ style "word-break" "break-all", classes "fl w-100 w-30-ns gray mv1" ] [ text "INTERFACE" ]
        , div [ style "word-break" "break-all", classes "fl w-100 w-70-ns mv1" ] [ span [ classes "fl w-100 black" ] (interfaceView moduleInfo.moduleInfo.interface) ]
        ]
