module Instances.Model exposing (..)


type alias Instance =
    { name : String
    , blueprintId : String
    , instance : String
    , peerId : String
    , ip : String
    }
