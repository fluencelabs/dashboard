module Route exposing (..)

import AirScripts.DiscoverPeers as DiscoverPeers
import BlueprintPage.View as BlueprintPage
import Html exposing (Html, text)
import HubPage.View as HubPage
import Model exposing (Model, Route(..))
import ModulePage.View as ModulePage
import Msg exposing (Msg)
import Port exposing (sendAir)
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
            case page of
                "" ->
                    HubPage.view model

                "hub" ->
                    HubPage.view model

                _ ->
                    text ("undefined page: " ++ page)

        Peer peer ->
            text peer

        Blueprint id ->
            BlueprintPage.view model id

        Module moduleName ->
            ModulePage.view model moduleName


routeCommand : Model -> Route -> Cmd msg
routeCommand m r =
    case r of
        Page _ ->
            sendAir (DiscoverPeers.air m.peerId m.relayId)

        Peer _ ->
            sendAir (DiscoverPeers.air m.peerId m.relayId)

        Blueprint _ ->
            sendAir (DiscoverPeers.air m.peerId m.relayId)

        Module _ ->
            sendAir (DiscoverPeers.air m.peerId m.relayId)
