module Modules.Model exposing (..)


type alias ModuleInfo =
    { name : String
    , instanceNumber : Int
    }


type alias Model =
    { modules : List ModuleInfo
    }
