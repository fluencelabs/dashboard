module Modules.Model exposing (..)

import Service.Model exposing (Interface)


type alias Module =
    { name : String
    , hash: String
    --, interface : Interface
    }


type alias ModuleShortInfo =
    { moduleInfo : Module
    , instanceNumber : Int
    }
