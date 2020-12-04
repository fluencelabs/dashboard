module AirScripts.GetAll exposing (..)

import Air exposing (Air, callBI, fold, next, par, relayEvent, seq, set)
import Json.Encode exposing (list, string)

air : String -> String -> List String -> Air
air peerId relayId peers =
    let
        clientIdSet =
            set "clientId" <| string peerId

        relayIdSet =
            set "relayId" <| string relayId

        peersSet =
            set "knownPeers" <| list string peers

        askRelay = (\innerAir ->
                par
                    (seq
                        (callBI "relayId" ( "op", "identity" ) [] Nothing)
                        (askAllAndSend "relayId")
                    )
                    innerAir
            )

        askPeers = (\innerAir ->
                par
                    (fold "knownPeers" "p" <|
                        par
                            (seq
                                (callBI "p" ( "op", "identity" ) [] Nothing)
                                (askAllAndSend "p")
                            )
                            (next "p")
                    )
                    innerAir
            )

        findAndAskNeighbours =
            seq
                (callBI "relayId" ( "op", "identity" ) [] Nothing)
                (seq
                    (callBI "relayId" ( "dht", "neighborhood" ) [ "clientId" ] (Just "neigh"))
                    (fold "neigh" "n" <|
                        par
                            (seq
                                (callBI "n" ( "dht", "neighborhood" ) [ "clientId" ] (Just "moreNeigh"))
                                (fold "moreNeigh" "mp" <|
                                    par
                                        (askAllAndSend "mp")
                                        (next "mp")
                                )
                            )
                            (next "n")
                    ))

    in
    clientIdSet <| relayIdSet <| peersSet <| (askRelay <| askPeers <| findAndAskNeighbours)

askAllAndSend : String -> Air
askAllAndSend var =
    (seq
        (callBI var ( "op", "identify" ) [] (Just "ident"))
        (seq
            (callBI var ( "dist", "get_blueprints" ) [] (Just "blueprints"))
            (seq
                (callBI var ( "dist", "get_modules" ) [] (Just "modules"))
                (seq
                    (callBI var ( "srv", "get_interfaces" ) [] (Just "interfaces"))
                    (relayEvent "all_info" [ var, "ident", "interfaces", "blueprints", "modules" ])
                )
            )
        )
    )
