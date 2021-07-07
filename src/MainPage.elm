port module MainPage exposing (..)

import AquaPorts.CollectPeerInfo exposing (collectPeerInfo)
import AquaPorts.CollectServiceInterface exposing (collectServiceInterface)
import Browser exposing (Document, UrlRequest)
import Browser.Navigation as Nav
import Cache exposing (Blueprint)
import Components.Spinner
import Dict
import Html exposing (Html, a, div, header, img, p, text)
import Html.Attributes exposing (attribute, style)
import Html.Events exposing (onClick)
import Pages.BlueprintPage
import Pages.Hub
import Pages.ModulePage
import Pages.NodesPage
import Palette exposing (classes)
import Route
import Url



-- model


type PageModel
    = Hub Pages.Hub.Model
    | Nodes Pages.NodesPage.Model
    | Blueprint (Maybe Pages.BlueprintPage.Model)
    | Module (Maybe Pages.ModulePage.Model)
    | Unknown String


pageModelFromCache : Route.Route -> Cache.Model -> PageModel
pageModelFromCache route cache =
    case route of
        Route.Home ->
            Hub (Pages.Hub.fromCache cache)

        Route.Hub ->
            Hub (Pages.Hub.fromCache cache)

        Route.Nodes ->
            Nodes (Pages.NodesPage.fromCache cache)

        Route.Blueprint id ->
            Blueprint (Pages.BlueprintPage.fromCache cache id)

        Route.Module moduleName ->
            let
                hash =
                    Dict.get moduleName cache.modulesByName

                m =
                    Maybe.andThen (Pages.ModulePage.fromCache cache) hash
            in
            Module m

        Route.Peer peer ->
            Unknown peer

        Route.Unknown s ->
            Unknown s


type alias Model =
    { peerId : String
    , relayId : String
    , key : Nav.Key
    , url : Url.Url
    , page : Route.Route
    , pageModel : PageModel
    , cache : Cache.Model
    , toggledInterface : Maybe String
    , knownPeers : List String
    , isInitialized : Bool
    }



-- view


view : Model -> Document Msg
view model =
    { title = title model, body = [ body model ] }


title : Model -> String
title _ =
    "Fluence Network Dashboard"


body : Model -> Html Msg
body model =
    layout <|
        [ header [ classes "w-100" ]
            [ div [ classes "w-100 fl pv2 bg-white one-edge-shadow" ]
                [ div [ classes "mw8-ns center ph3" ]
                    [ div [ classes "fl mv1 pl3" ]
                        [ a [ attribute "href" "/" ]
                            [ img
                                [ classes "mw-100"
                                , style "height" "30px"
                                , attribute "src" "/images/logo_new.svg"
                                , style "position" "relative"
                                , style "top" "0.16rem"
                                ]
                                []
                            ]
                        ]
                    , div [ classes "fl pl5 h-auto" ]
                        [ p [ classes "h-100 m-auto fw4" ]
                            [ a [ attribute "href" "/", classes "link black" ] [ text "Developer Hub" ]
                            ]
                        ]
                    , div [ classes "fl pl5 h-auto" ]
                        [ p [ classes "h-100 m-auto fw4" ]
                            [ a [ attribute "href" "/nodes", classes "link black" ] [ text "Nodes" ]
                            ]
                        ]
                    , div [ classes "fl fr" ]
                        [ a [ attribute "href" "/" ]
                            [ img
                                [ classes "mw-100"
                                , style "height" "20px"
                                , attribute "src" "/images/reload.svg"
                                , style "position" "relative"
                                , style "top" "0.85rem"
                                , onClick Reload
                                ]
                                []
                            ]
                        ]
                    ]
                ]
            ]
        , div [ classes "mw8-ns center w-100 pa4 pt3 mt4" ] [ routeView model.pageModel ]
        ]


layout : List (Html Msg) -> Html Msg
layout elms =
    div [ classes "center w-100" ]
        [ div [ classes "fl w-100" ]
            ([]
                ++ elms
            )
        ]


routeView : PageModel -> Html msg
routeView model =
    case model of
        Hub m ->
            Pages.Hub.view m

        Nodes m ->
            Pages.NodesPage.view m

        Blueprint m ->
            case m of
                Just mm ->
                    Pages.BlueprintPage.view mm

                Nothing ->
                    div []
                        Components.Spinner.view

        Module m ->
            case m of
                Just mm ->
                    Pages.ModulePage.view mm

                Nothing ->
                    div []
                        Components.Spinner.view

        Unknown s ->
            text ("Not found: " ++ s)



-- msg


type Msg
    = NoOp
    | UrlChanged Url.Url
    | LinkClicked UrlRequest
    | RelayChanged String
    | ToggleInterface String
    | Reload
    | Cache Cache.Msg



-- update


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        UrlChanged url ->
            let
                route =
                    Route.parse url

                cmd =
                    routeCommand model route
            in
            ( { model | url = url, isInitialized = True, page = route, toggledInterface = Nothing }, cmd )

        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        Cache cacheMsg ->
            let
                newCache =
                    Cache.update model.cache cacheMsg

                newPagesModel =
                    pageModelFromCache model.page model.cache
            in
            ( { model
                | cache = newCache
                , pageModel = newPagesModel
              }
            , Cmd.none
            )

        ToggleInterface id ->
            case model.toggledInterface of
                Just ti ->
                    ( { model
                        | toggledInterface =
                            if id == ti then
                                Nothing

                            else
                                Just id
                      }
                    , Cmd.none
                    )

                Nothing ->
                    ( { model | toggledInterface = Just id }, Cmd.none )

        RelayChanged relayId ->
            ( { model | relayId = relayId }, Cmd.none )

        Reload ->
            ( model, getAll { relayPeerId = model.relayId, knownPeers = model.knownPeers } )



-- subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ collectServiceInterface (\si -> si |> Cache.CollectServiceInterface |> Cache)
        , collectPeerInfo (\si -> si |> Cache.CollectPeerInfo |> Cache)
        , relayChanged RelayChanged
        ]



-- ports


port relayChanged : (String -> msg) -> Sub msg


type alias GetAll =
    { relayPeerId : String
    , knownPeers : List String
    }


port getAll : GetAll -> Cmd msg



-- commands


getAllCmd : String -> String -> List String -> Cmd msg
getAllCmd peerId relayId knownPeers =
    Cmd.batch
        [ getAll { relayPeerId = relayId, knownPeers = knownPeers }
        ]


routeCommand : Model -> Route.Route -> Cmd msg
routeCommand m _ =
    if m.isInitialized then
        Cmd.none

    else
        getAllCmd m.peerId m.relayId m.knownPeers
