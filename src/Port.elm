port module Port exposing (..)

import Blueprints.Model exposing (Blueprint)
import Dict exposing (Dict)
import Json.Encode exposing (Value)
import Modules.Model exposing (Module)
import Nodes.Model exposing (Identify)
import Service.Model exposing (Service)


type alias ReceiveEvent =
    { name : String, peer : String, peers : Maybe (List String), identify : Maybe Identify, services : Maybe (List Service), modules : Maybe (List Module), blueprints : Maybe (List Blueprint) }


port eventReceiver : (ReceiveEvent -> msg) -> Sub msg


port relayChanged : (String -> msg) -> Sub msg


type alias GetAll =
    { relayPeerId : String
    , knownPeers : List String
    }


port getAll : GetAll -> Cmd msg
