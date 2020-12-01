module BlueprintPage.Model exposing (..)

import Blueprints.Model exposing (Blueprint)
import Modules.Model exposing (Module)


type alias BlueprintViewInfo =
    { name : String
    , id : String
    , author : String
    , authorPeerId : String
    , description : String
    , website : String
    , blueprint : Blueprint
    , modules : List Module
    }
