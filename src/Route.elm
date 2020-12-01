module Route exposing (..)

import AirScripts.DiscoverPeers as DiscoverPeers
import Html exposing (Html, text)
import HubPage.View as HubPage
import Model exposing (Model, Route(..))
import ModulePage.View as ModulePage
import Port exposing (sendAir)
import Url.Parser exposing ((</>), Parser, map, oneOf, s, string)


routeParser : Parser (Route -> a) a
routeParser =
    oneOf
        [ map Peer (s "peer" </> string)
        , map Module (s "module" </> string)
        , map Service (s "service" </> string)
        , map Page string
        ]


parse url =
    Maybe.withDefault (Page "") <| Url.Parser.parse routeParser url


routeView : Model -> Route -> Html msg
routeView model route =
    let
        _ =
            Debug.log "page" route
    in
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

        Service serviceId ->
            text serviceId

        Module moduleName ->
            ModulePage.view model moduleName



routeCommand : Model -> Route -> Cmd msg
routeCommand m r =
    case r of
        Page s ->
            sendAir (DiscoverPeers.air m.peerId m.relayId)

        Peer _ ->
            sendAir (DiscoverPeers.air m.peerId m.relayId)

        Service string ->
            sendAir (DiscoverPeers.air m.peerId m.relayId)

        Module string ->
            sendAir (DiscoverPeers.air m.peerId m.relayId)
