module Modules.Model exposing (..)


type alias ModuleShortInfo =
    { name : String
    , instanceNumber : Int
    }


type alias Model =
    { modules : List ModuleShortInfo
    }
