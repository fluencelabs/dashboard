port module Port exposing (..)

import Air exposing (Air(..))
import Dict exposing (Dict)
import Json.Encode exposing (Value)
import Services.Model exposing (Service)


type alias SendParticle =
    { script : String, data : Value }


type alias ReceiveEvent =
    { name : String, peer : String, peers : Maybe (List String), services : Maybe (List Service), modules : Maybe (List String) }


port sendParticle : SendParticle -> Cmd msg


port eventReceiver : (ReceiveEvent -> msg) -> Sub msg


port relayChanged : (String -> msg) -> Sub msg


sendAir : Air -> Cmd msg
sendAir (Air dataDict script) =
    let
        data =
            Json.Encode.object <| Dict.toList dataDict
    in
    sendParticle { script = script, data = data }
