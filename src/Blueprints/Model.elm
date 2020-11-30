module Blueprints.Model exposing (..)


type alias Blueprint =
    { dependencies : List String
    , id : String
    , name : String
    }
