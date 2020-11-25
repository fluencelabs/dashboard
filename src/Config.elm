module Config exposing (..)


type alias Config =
    { peerId : String
    , relayId : String
    }


type alias Flags =
    Config
