port module Port exposing (..)

import Blueprints.Model exposing (Blueprint)
import Dict exposing (Dict)
import Json.Encode exposing (Value)
import Modules.Model exposing (Module)
import Nodes.Model exposing (Identify)
import Service.Model exposing (Interface, Service)


type alias ServiceInfo =
    { id : String
    , blueprint_id : String
    , owner_id : String
    }


type alias CollectPeerInfo =
    { peerId : String
    , identify : Maybe Identify
    , services : Maybe (List ServiceInfo)
    , modules : Maybe (List Module)
    , blueprints : Maybe (List Blueprint)
    }


port collectPeerInfo : (CollectPeerInfo -> msg) -> Sub msg


type alias CollectServiceInterface =
    { peer_id : String
    , service_id : String
    , interface : Interface
    }


port collectServiceInterface : (CollectServiceInterface -> msg) -> Sub msg


port relayChanged : (String -> msg) -> Sub msg


type alias GetAll =
    { relayPeerId : String
    , knownPeers : List String
    }


port getAll : GetAll -> Cmd msg
