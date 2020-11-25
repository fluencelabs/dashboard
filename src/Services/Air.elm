module Services.Air exposing (..)

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
            set "peers" <| list string peers

        airScript =
            seq
                (callBI "relayId" ( "op", "identity" ) [ ] Nothing)
                (fold "peers" "p" <|
                    par
                        (seq
                            (callBI "p" ( "srv", "get_interfaces" ) [ ] (Just "interfaces"))
                            (relayEvent "services_discovered" [ "p", "interfaces" ])
                        )
                        (next "p")
                )
    in
        clientIdSet <| relayIdSet <| peersSet <| airScript

