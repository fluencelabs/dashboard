port module AquaPorts.CollectPeerInfo exposing (..)


type alias Service =
    { id : String
    , blueprint_id : String
    , owner_id : String
    }


type alias ModuleConfig =
    { name : String
    }


type alias Module =
    { name : String
    , hash : String
    , config : ModuleConfig
    }


type alias Identify =
    { external_addresses : List String }


type alias Blueprint =
    { id : String
    , name : String
    , dependencies : List String
    }


type alias PeerInfo =
    { peerId : String

    --, identify : Maybe Identify
    --, services : Maybe (List Service)
    --, modules : Maybe (List Module)
    , blueprints : Maybe (List Blueprint)
    }


port collectPeerInfo : (PeerInfo -> msg) -> Sub msg
