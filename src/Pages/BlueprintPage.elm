module Pages.BlueprintPage exposing (Model, fromCache, view)

import Array exposing (Array)
import Cache exposing (BlueprintId)
import Dict exposing (Dict)
import Html exposing (Html, article, div, span, text)
import Html.Events exposing (onClick)
import Info exposing (..)
import List.Unique exposing (..)
import Maybe.Extra as Maybe
import Msg exposing (Msg(..))
import Palette exposing (classes, darkRed, redFont)
import Services.ServiceRow
import Services.ServicesTable
import Utils.Html exposing (..)



-- model


type alias Model =
    { name : String
    , id : String
    , author : String
    , authorPeerId : String
    , description : String
    , website : String

    -- , blueprint : Blueprint
    , moduleNames : List String
    , services : Services.ServicesTable.Model
    , openedModule : Maybe String
    }


fromCache : Cache.Model -> BlueprintId -> Maybe Model
fromCache cache id =
    let
        bp =
            Dict.get id cache.blueprintsById

        services =
            Dict.get id cache.servicesByBlueprintId
                |> Maybe.withDefault Array.empty
                |> Array.toList
                |> Services.ServicesTable.fromCache cache

        res =
            Maybe.map
                (\x ->
                    { name = x.name
                    , id = x.id
                    , author = "Fluence Labs"
                    , authorPeerId = "fluence_labs_peer_id"
                    , description = getBlueprintDescription x.id
                    , website = "https://github.com/fluencelabs/"

                    -- , blueprint = "Blueprint"
                    , moduleNames = []
                    , services = services
                    , openedModule = Nothing
                    }
                )
                bp
    in
    res



-- view


view : Model -> Html Msg
view model =
    let
        instancesCount =
            model.services
                |> List.length
                |> String.fromInt
    in
    div [ classes "fl w-100" ]
        [ div [ classes "fl w-100 pb4 pt4" ]
            [ div [ redFont, classes "f1 fw4 pt3 pb2" ] [ text ("Blueprint: " ++ model.name) ]
            , span [ classes "fl w-100", darkRed ] [ text ("ID: " ++ model.id) ]
            ]
        , div [ classes "fl w-100 bg-white mt2 ph4 pt3 mb5 pb3 br3" ]
            [ article [ classes "cf" ]
                [ div [ classes "fl w-20-ns gray-font mv3" ] [ text "AUTHOR" ]
                , div [ classes "fl w-80-ns mv3 lucida" ]
                    [ span [ classes "fl black b" ] [ text (textOrBsp model.author) ] ]
                , div [ classes "fl w-20-ns gray-font mv3" ] [ text "DESCRIPTION" ]
                , div [ classes "fl w-80-ns mv3 cf" ]
                    [ span [ classes "fl black lucida pv1" ] [ text (textOrBsp model.description) ] ]
                , div [ classes "fl w-20-ns gray-font mv3" ] [ text "MODULES" ]
                , div [ classes "fl w-80-ns mv3" ]
                    [ text
                        (textOrBsp
                            (String.join ", " model.moduleNames)
                        )
                    ]

                --(blueprintInfo.modules
                --    |> List.map (\m -> viewToggledInterface (checkToggle m.name) m.name)
                --)
                ]
            ]
        , div [ classes "pt4 fw5 f3 pb4" ]
            [ text
                ("Services (" ++ instancesCount ++ ")")
            ]
        , div [ classes "fl w-100 mt2 mb4 bg-white br3" ]
            [ Services.ServicesTable.view model.services
            ]
        ]


viewToggledInterface : Bool -> String -> Html Msg
viewToggledInterface isOpen name =
    let
        interfaceViewEl =
            if isOpen then
                --[ div [ classes "fl w-100 ph3" ] (interfaceView interface) ]
                []

            else
                []
    in
    div []
        ([ div [ classes "fl w-100 light-shadow bg-near-white pa2 mv2 pointer", onClick (ToggleInterface name) ]
            [ span [ classes "fl mh2 pv1 tldib v-mid dib v-mid" ] [ text name ]

            --, a [ attribute "href" ("/module/" ++ name), classes "fl dib v-mid mt1" ] [ img [ attribute "src" "/images/link.svg" ] [] ]
            --, div [ classes "fl o-40 f4 fr pr3 dib v-mid" ]
            --    [ if isOpen then
            --        text "▲"
            --
            --      else
            --        text "▼"
            --    ]
            ]
         ]
         --++ interfaceViewEl
        )
