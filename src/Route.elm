module Route exposing (..)

import Components.Spinner
import Dict exposing (Dict)
import Html exposing (Html, div, text)
import Model exposing (Model, Route(..))
import ModulePage.View as ModulePage
import Msg exposing (Msg)
import Pages.BlueprintPage
import Pages.Hub
import Pages.NodesPage
import Port exposing (getAll)
import Url.Parser exposing ((</>), Parser, map, oneOf, s, string)


routeParser : Parser (Route -> a) a
routeParser =
    oneOf
        [ map Peer (s "peer" </> string)
        , map Module (s "module" </> string)
        , map Blueprint (s "blueprint" </> string)
        , map Page string
        ]


parse url =
    Maybe.withDefault (Page "") <| Url.Parser.parse routeParser url


routeView : Model -> Route -> Html Msg
routeView model route =
    case route of
        Page page ->
            let
                res =
                    case page of
                        "" ->
                            Pages.Hub.view model.pageModel.hub

                        "hub" ->
                            Pages.Hub.view model.pageModel.hub

                        "nodes" ->
                            Pages.NodesPage.view model.pageModel.nodes

                        _ ->
                            text ("undefined page: " ++ page)
            in
            res

        Peer peer ->
            text peer

        Blueprint id ->
            case Pages.BlueprintPage.fromCache model.cache id of
                Just m ->
                    Pages.BlueprintPage.view m

                Nothing ->
                    div []
                        Components.Spinner.view

        Module moduleName ->
            ModulePage.view model moduleName


getAllCmd : String -> String -> List String -> Cmd msg
getAllCmd peerId relayId knownPeers =
    Cmd.batch
        [ getAll { relayPeerId = relayId, knownPeers = knownPeers }
        ]


routeCommand : Model -> Route -> Cmd msg
routeCommand m _ =
    if m.isInitialized then
        Cmd.none

    else
        getAllCmd m.peerId m.relayId m.knownPeers
