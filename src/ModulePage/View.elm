module ModulePage.View exposing (..)

import Dict exposing (Dict)
import Html exposing (Html, a, article, div, span, text)
import Html.Attributes exposing (attribute, property)
import Info exposing (getDescription, getSite)
import Instances.View
import Interface.View exposing (interfaceView)
import Json.Encode exposing (string)
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
                [ div [ classes "fl w-100 mb2 pt4 pb4" ]
                    [ div [ redFont, classes "f1 fw4 pt3" ] [ text ("Module: " ++ mi.name) ]
                    ]
                , div [ classes "fl w-100 bg-white mt2 ph4 pt3 mb4 pb2 br3" ] [ viewInfo mi ]
                , div [ classes "pt4 fw5 f3 pb4" ] [ text ("Services (" ++ String.fromInt instanceNum ++ ")") ]
                , div [ classes "fl w-100 mt2 mb4 bg-white br3" ] [ instanceView ]
                ]

        Nothing ->
            div [ classes "cf ph2-ns" ]
                []


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


resString =
    String.fromChar (Char.fromCode 160)


empty =
    span [] [ text resString ]


viewInfo : ModuleViewInfo -> Html msg
viewInfo moduleInfo =
    article [ classes "cf" ]
        [ div [ classes "fl w-100 w-20-ns gray mv3" ] [ text "AUTHOR" ]
        , div [ classes "fl w-100 w-80-ns mv3" ]
            [ span [ classes "fl w-100 black b lucida" ] [ text moduleInfo.author ] ]
        , div [ classes "fl w-100 w-20-ns gray mv3" ] [ text "WEBSITE" ]
        , div [ classes "fl w-100 w-80-ns mv3 lucida" ]
            [ if moduleInfo.website == "" then
                empty

              else
                a [ attribute "href" moduleInfo.website, classes "fl w-100 fluence-red" ] [ text moduleInfo.website ]
            ]
        , div [ classes "fl w-100 w-20-ns gray mv3" ] [ text "DESCRIPTION" ]
        , div [ classes "fl w-100 w-80-ns mv3 lucida" ]
            [ span [ classes "fl w-100 black", property "innerHTML" (string "&nbsp;123") ] [ text moduleInfo.description ] ]
        , div [ classes "fl w-100 w-20-ns gray mv3" ] [ text "INTERFACE" ]
        , div [ classes "fl w-100 w-80-ns mv3" ]
            [ span [ classes "fl w-100 black" ] (interfaceView moduleInfo.moduleInfo.interface) ]
        ]
