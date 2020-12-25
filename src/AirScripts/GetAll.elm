module AirScripts.GetAll exposing (..)

import Air exposing (Air, callBI, flattenOp, fold, next, par, relayEvent, seq, set)
import Json.Encode exposing (list, string)


askRelaySchema : Air
askRelaySchema =
    seq
        (callBI "relayId" ( "op", "identity" ) [] Nothing)
        (askAllAndSend "relayId")


askRelayScript : String -> String -> Air
askRelayScript peerId relayId =
    let
        clientIdSet =
            set "clientId" <| string peerId

        relayIdSet =
            set "relayId" <| string relayId
    in
    clientIdSet <| relayIdSet <| askRelaySchema


askPeersSchema : Air
askPeersSchema =
    fold "knownPeers" "p" <|
        par
            (seq
                (callBI "p" ( "op", "identity" ) [] Nothing)
                (askAllAndSend "p")
            )
            (next "p")


askPeersScript : String -> String -> List String -> Air
askPeersScript peerId relayId peers =
    let
        clientIdSet =
            set "clientId" <| string peerId

        relayIdSet =
            set "relayId" <| string relayId

        peersSet =
            set "knownPeers" <| list string peers
    in
    clientIdSet <| relayIdSet <| peersSet <| askPeersSchema


findAndAskNeighboursSchema : Air
findAndAskNeighboursSchema =
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
            )
        )


findAndAskNeighboursScript : String -> String -> Air
findAndAskNeighboursScript peerId relayId =
    let
        clientIdSet =
            set "clientId" <| string peerId

        relayIdSet =
            set "relayId" <| string relayId
    in
    clientIdSet <| relayIdSet <| findAndAskNeighboursSchema


air : String -> String -> List String -> Air
air peerId relayId peers =
    let
        clientIdSet =
            set "clientId" <| string peerId

        relayIdSet =
            set "relayId" <| string relayId

        peersSet =
            set "knownPeers" <| list string peers

        askRelay =
            \innerAir ->
                seq
                    (callBI "relayId" ( "op", "identity" ) [] Nothing)
                    (par
                        askRelaySchema
                        innerAir
                    )

        askPeers =
            \innerAir ->
                par
                    askPeersSchema
                    innerAir
    in
    clientIdSet <| relayIdSet <| peersSet <| (askRelay <| askPeers <| findAndAskNeighboursSchema)


askAllAndSend : String -> Air
askAllAndSend var =
    seq
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
