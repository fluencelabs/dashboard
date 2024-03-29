port module AquaPorts.CollectPeerInfo exposing (..)


type alias ServiceDto =
    { id : String
    , blueprint_id : String
    , owner_id : String
    }


type alias ModuleConfigDto =
    { name : String
    }

type alias ModuleDto =
    { name : String
    , hash : String
    }


type alias IdentifyDto =
    { external_addresses : List String }


type alias BlueprintDto =
    { id : String
    , name : String
    , dependencies : List String
    }


type alias PeerDto =
    { peerId : String
    , identify : Maybe IdentifyDto
    , services : Maybe (List ServiceDto)
    , modules : Maybe (List ModuleDto)
    , blueprints : Maybe (List BlueprintDto)
    }


port collectPeerInfo : (PeerDto -> msg) -> Sub msg
