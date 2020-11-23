port module Port exposing (..)

import  Air exposing (Air(..))
import Dict exposing (Dict)
import Json.Encode exposing (Value)

type alias SendParticle = {script: String, data: Value}

type alias ReceiveEvent = {name: String, args: List Value}

port sendParticle: SendParticle -> Cmd msg

port eventReceiver: (ReceiveEvent -> msg) -> Sub msg

port relayChanged: (String -> msg) -> Sub msg

sendAir: Air -> Cmd msg
sendAir (Air dataDict script) =
    let
        data = Json.Encode.object <| Dict.toList dataDict
    in
        sendParticle {script = script, data = data}