module AirScripts.CallPeers exposing (..)

import Air exposing (Air, callBI, fold, next, par, relayEvent, seq, set)
import Json.Encode exposing (list, string)


air : String -> String -> ( String, String, String ) -> List String -> Air
air peerId relayId ( event, service, fnName ) peers =
    let
        clientIdSet =
            set "clientId" <| string peerId

        relayIdSet =
            set "relayId" <| string relayId

        peersSet =
            set "peers" <| list string peers

        airScript =
            seq
                (callBI "relayId" ( "op", "identity" ) [] Nothing)
                (fold "peers" "p" <|
                    par
                        (seq
                            (callBI "p" ( service, fnName ) [] (Just "result"))
                            (relayEvent event [ "p", "result" ])
                        )
                        (next "p")
                )
    in
    clientIdSet <| relayIdSet <| peersSet <| airScript
