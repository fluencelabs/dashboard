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
            set "peers" <| list string peers

        airScript =
            seq
                (callBI "relayId" ( "op", "identity" ) [] Nothing)
                (fold "peers" "p" <|
                    par
                        (seq
                            (callBI "p" ( "op", "identify" ) [] (Just "ident"))
                            (seq
                                (callBI "p" ( "dist", "get_blueprints" ) [] (Just "blueprints"))
                                (seq
                                    (callBI "p" ( "dist", "get_modules" ) [] (Just "modules"))
                                    (seq
                                        (callBI "p" ( "srv", "get_interfaces" ) [] (Just "interfaces"))
                                        (relayEvent "all_info" [ "p", "ident", "interfaces", "blueprints", "modules" ])
                                    )
                                )
                            )
                        )
                        (next "p")
                )
    in
    clientIdSet <| relayIdSet <| peersSet <| airScript
