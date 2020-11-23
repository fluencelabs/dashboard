module Config exposing (..)

type alias Config =
    { peerId: String
    , windowSize : { width : Int, height : Int }
    }


type alias Flags =
    Config
