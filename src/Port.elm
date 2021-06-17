port module Port exposing (..)

import Blueprints.Model exposing (Blueprint)
import Dict exposing (Dict)
import Json.Encode exposing (Value)
import Modules.Model exposing (Module)
import Nodes.Model exposing (Identify)
import Service.Model exposing (Service)


type alias CollectPeerInfo =
    { peerId : String
    , identify : Maybe Identify
    , services : Maybe (List Service)
    , modules : Maybe (List Module)
    , blueprints : Maybe (List Blueprint)
    }


port collectPeerInfo : (CollectPeerInfo -> msg) -> Sub msg


type alias FunctionSignature =
    { arguments : List String
    , name : String
    , output_types : List String
    }


type alias RecordType =
    { fields : List String
    , id : Int
    , name : String
    }


type alias ServiceInterface =
    { function_signatures : List FunctionSignature
    , record_types : List RecordType
    }


type alias CollectServiceInterface =
    { blueprint_id : String
    , service_id : String
    , interface : ServiceInterface
    }


port collectServiceInterface : (CollectServiceInterface -> msg) -> Sub msg


port relayChanged : (String -> msg) -> Sub msg


type alias GetAll =
    { relayPeerId : String
    , knownPeers : List String
    }


port getAll : GetAll -> Cmd msg
