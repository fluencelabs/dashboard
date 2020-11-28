module Route exposing (..)

import Air exposing (callBI, fold, next, par, relayEvent, seq, set)
import Dict
import Html exposing (Html)
import HubPage.View as HubPage
import Json.Encode as Encode
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
    case route of
        Page page ->
            case page of
                "" ->
                    HubPage.view model
                "hub" ->
                    HubPage.view model


                _ ->
                    Html.text ("undefined page: " ++ page)

        Peer peer ->
            Html.text peer

        Service serviceId ->
            Html.text serviceId

        Module moduleName ->
            let
                up =
                    \( pid, p ) -> Maybe.map (\a -> Tuple.pair pid a) (List.head (List.drop 0 p.services))

                el =
                    List.head (List.drop 2 (Dict.toList model.discoveredPeers))
            in
            case Maybe.andThen up el of
                Just ( peerId, service ) ->
                    let
                        example =
                            { name = moduleName
                            , id = service.service_id
                            , author = "Fluence Labs"
                            , authorPeerId = peerId
                            , description = "Cool service"
                            , website = "https://github.com/fluencelabs/chat"
                            , service = service
                            }
                    in
                    ModulePage.view example

                Nothing ->
                    Html.text moduleName

getPeers : Model -> Cmd msg
getPeers m =
    let
        clientId =
            set "clientId" <| Encode.string m.peerId

        relayId =
            set "relayId" <| Encode.string m.relayId

        air =
            seq
                (callBI "relayId" ( "dht", "neighborhood" ) [ "clientId" ] (Just "peers"))
                (par
                    (relayEvent "peers_discovered" [ "relayId", "peers" ])
                    (fold "peers" "p" <|
                        par
                            (seq
                                (callBI "p" ( "dht", "neighborhood" ) [ "clientId" ] (Just "morePeers"))
                                (relayEvent "peers_discovered" [ "p", "morePeers" ])
                            )
                            (next "p")
                    )
                )
    in
    sendAir (relayId <| clientId <| air)

routeCommand : Model -> Route -> Cmd msg
routeCommand m r =
    case r of
        Page s ->
            getPeers m

        Peer _ ->
            getPeers m

        Service string ->
            getPeers m


        Module string ->
            getPeers m

