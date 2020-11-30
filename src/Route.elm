module Route exposing (..)

import AirScripts.DiscoverPeers as DiscoverPeers
import Html exposing (Html, text)
import HubPage.View as HubPage
import Model exposing (Model, Route(..))
import Port exposing (sendAir)
import ServicePage.View as ServicePage
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
        _ = Debug.log "page" route
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
            ServicePage.view model serviceId

        Module moduleName ->
            text moduleName


routeCommand : Model -> Route -> Cmd msg
routeCommand m r =
    case r of
        Page s ->
            sendAir (DiscoverPeers.air m.peerId m.relayId)

        Peer _ ->
            Cmd.none

        Service string ->
            Cmd.none

        Module string ->
            Cmd.none
