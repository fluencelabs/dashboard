module ModulePage.Model exposing (..)

import Modules.Model exposing (Module)


type alias ModuleViewInfo =
    { name : String
    , id : String
    , author : String
    , authorPeerId : String
    , description : String
    , website : String
    , moduleInfo : Module
    }
