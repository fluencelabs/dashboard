module Modules.Model exposing (..)

import Service.Model exposing (Interface)


type alias Module =
    { name : String
    , interface : Interface
    }


type alias ModuleShortInfo =
    { moduleInfo : Module
    , instanceNumber : Int
    }
