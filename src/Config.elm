module Config exposing (..)


type alias Config =
    { peerId : String
    , relayId : String
    , knownPeers : List String
    }


type alias Flags =
    Config
