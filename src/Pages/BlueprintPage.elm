module Pages.BlueprintPage exposing (Model, fromCache, view)

import Cache exposing (BlueprintId)
import Dict exposing (Dict)
import Html exposing (Html, a, article, div, img, span, strong, text)
import Html.Attributes exposing (attribute)
import Html.Events exposing (onClick)
import Info exposing (..)
import List.Unique exposing (..)
import Modules.Model exposing (Module)
import Msg exposing (Msg(..))
import Palette exposing (classes, darkRed, redFont)
import Service.Model exposing (Interface)
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
    , openedModule : Maybe String
    }


fromCache : Cache.Model -> BlueprintId -> Maybe Model
fromCache cache id =
    let
        bp =
            Dict.get id cache.blueprintsById

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
                    , openedModule = Nothing
                    }
                )
                bp
    in
    res



-- view


view : Model -> Html Msg
view model =
    article [ classes "cf" ]
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
