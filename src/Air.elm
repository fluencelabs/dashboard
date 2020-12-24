module Air exposing (..)

import Dict exposing (Dict)
import Json.Encode exposing (Value)


type Air
    = Air (Dict String Value) String


call : String -> String -> List String -> Maybe String -> Air
call peerPart fnPart args res =
    let
        captureResult =
            case res of
                Just n ->
                    " " ++ n

                Nothing ->
                    ""
    in
    Air Dict.empty ("(call " ++ peerPart ++ " " ++ fnPart ++ " [" ++ String.join " " args ++ "]" ++ captureResult ++ ")\n")


callBI : String -> ( String, String ) -> List String -> Maybe String -> Air
callBI p ( s, f ) args cap =
    call p ("(\"" ++ s ++ "\" \"" ++ f ++ "\")") args cap


event : String -> List String -> Air
event name args =
    callBI "%init_peer_id%" ( "event", name ) args Nothing


combine : String -> Air -> Air -> Air
combine combName (Air ld ls) (Air rd rs) =
    Air (Dict.union ld rd) ("(" ++ combName ++ "\n " ++ ls ++ "\n " ++ rs ++ ")\n")


seq =
    combine "seq"


par =
    combine "par"


xor =
    combine "xor"


fold : String -> String -> Air -> Air
fold iter item (Air d s) =
    Air d ("(fold " ++ iter ++ " " ++ item ++ "\n" ++ s ++ ")\n")


flattenOp : String -> String
flattenOp s =
    s ++ '!'


next : String -> Air
next item =
    Air Dict.empty ("(next " ++ item ++ ")\n")


set : String -> Value -> Air -> Air
set name value (Air d s) =
    Air (Dict.insert name value d) s



-- Assumes that relay's id is set to relayId: moves execution to init peer, executes here


relayEvent : String -> List String -> Air
relayEvent name args =
    seq
        (callBI "relayId" ( "op", "identity" ) [] Nothing)
    <|
        event name args
