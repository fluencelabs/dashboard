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


event : String -> List String -> Air
event name args =
    call "%init_peer_id%" ("(\"event\" \"" ++ name ++ "\")") args Nothing


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


next : String -> Air
next item =
    Air Dict.empty ("(next " ++ item ++ ")\n")
