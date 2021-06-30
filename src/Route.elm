module Route exposing (..)

import BlueprintPage.View as BlueprintPage
import Dict exposing (Dict)
import Html exposing (Html, text)
import Model exposing (Model, Route(..))
import ModulePage.View as ModulePage
import Msg exposing (Msg)
import NodePage.View as NodePage
import Pages.Hub as HubPage
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
                            HubPage.view model.pageModel.hub

                        "hub" ->
                            HubPage.view model.pageModel.hub

                        "nodes" ->
                            NodePage.view model

                        _ ->
                            text ("undefined page: " ++ page)
            in
            res

        Peer peer ->
            text peer

        Blueprint id ->
            BlueprintPage.view model id

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
