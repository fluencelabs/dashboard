module Pages.ModulePage exposing (Model, fromCache, view)

import AquaPorts.CollectServiceInterface exposing (InterfaceDto)
import Cache exposing (Hash)
import Dict
import Html exposing (Html, a, article, div, span, text)
import Html.Attributes exposing (attribute)
import Info exposing (getModuleDescription)
import Modules.Interface
import Palette exposing (classes, redFont)
import Services.ServicesTable
import Utils.Html exposing (textOrBsp)



-- model


type alias Model =
    { name : String
    , hash : String
    , author : String
    , authorPeerId : String
    , description : String
    , website : String
    , services : Services.ServicesTable.Model
    , interface : Maybe InterfaceDto
    }


fromCache : Cache.Model -> Hash -> Maybe Model
fromCache cache hash =
    let
        m =
            Dict.get hash cache.modulesByHash

        services =
            Cache.getServicesThatUseModule cache hash

        res =
            Maybe.map
                (\x ->
                    { name = x.name
                    , hash = x.hash
                    , author = "Fluence Labs"
                    , authorPeerId = "fluence_labs_peer_id"
                    , description = getModuleDescription x.name
                    , website = "https://github.com/fluencelabs/"
                    , services = Services.ServicesTable.fromCache cache services
                    , interface = Nothing
                    }
                )
                m
    in
    res



-- view


view : Model -> Html msg
view model =
    let
        numberOfInstances =
            List.length model.services
    in
    div [ classes "fl w-100 cf ph2-ns" ]
        [ div [ classes "fl w-100 mb2 pt4 pb4" ]
            [ div [ redFont, classes "f1 fw4 pt3" ] [ text ("Module: " ++ model.name) ]
            ]
        , div [ classes "fl w-100 bg-white mt2 ph4 pt3 mb4 pb2 br3" ]
            [ article [ classes "cf" ]
                [ div [ classes "fl w-100 w-20-ns gray mv3" ] [ text "AUTHOR" ]
                , div [ classes "fl w-100 w-80-ns mv3" ]
                    [ span [ classes "fl w-100 black b lucida" ] [ text model.author ] ]
                , div [ classes "fl w-100 w-20-ns gray mv3" ] [ text "WEBSITE" ]
                , div [ classes "fl w-100 w-80-ns mv3 lucida" ]
                    [ a [ attribute "href" model.website, classes "fl w-100 fluence-red" ] [ text (textOrBsp model.website) ]
                    ]
                , div [ classes "fl w-100 w-20-ns gray mv3" ] [ text "DESCRIPTION" ]
                , div [ classes "fl w-100 w-80-ns mv3 lucida" ]
                    [ span [ classes "fl w-100 black" ] [ text (textOrBsp model.description) ] ]

                -- , div [ classes "fl w-100 w-20-ns gray mv3" ] [ text "INTERFACE" ]
                -- , div [ classes "fl w-100 w-80-ns mv3" ]
                --     [ span [ classes "fl w-100 black" ]
                --         (Modules.Interface.view model.interface)
                --     ]
                ]
            ]
        , div [ classes "pt4 fw5 f3 pb4" ] [ text ("Services (" ++ String.fromInt numberOfInstances ++ ")") ]
        , div [ classes "fl w-100 mt2 mb4 bg-white br3" ] [ Services.ServicesTable.view model.services ]
        ]
