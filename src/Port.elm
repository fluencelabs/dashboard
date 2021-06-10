port module Port exposing (..)

import Air exposing (Air(..))
import Blueprints.Model exposing (Blueprint)
import Dict exposing (Dict)
import Json.Encode exposing (Value)
import Modules.Model exposing (Module)
import Nodes.Model exposing (Identify)
import Service.Model exposing (Service)


type alias SendParticle =
    { script : String, data : Value }


type alias ReceiveEvent =
    { name : String, peer : String, peers : Maybe (List String), identify : Maybe Identify, services : Maybe (List Service), modules : Maybe (List Module), blueprints : Maybe (List Blueprint) }


port sendParticle : SendParticle -> Cmd msg


port eventReceiver : (ReceiveEvent -> msg) -> Sub msg


port relayChanged : (String -> msg) -> Sub msg


type alias GetAll =
    { relayPeerId : String
    , knownPeers : List String
    }


port getAll : GetAll -> Cmd msg


sendAir : Air -> Cmd msg
sendAir (Air dataDict script) =
    let
        data =
            Json.Encode.object <| Dict.toList dataDict
    in
    sendParticle { script = script, data = data }
