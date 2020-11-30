module AirScripts.DiscoverPeers exposing (..)

import Air exposing (Air, callBI, fold, next, par, relayEvent, seq, set)
import Json.Encode as Encode

air : String -> String -> Air
air peerId relayId =
    let
        clientIdSet =
            set "clientId" <| Encode.string peerId

        relayIdSet =
            set "relayId" <| Encode.string relayId

        airScript =
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
        (relayIdSet <| clientIdSet <| airScript)