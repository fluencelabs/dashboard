module Blueprints.Model exposing (..)


type alias Blueprint =
    { dependencies : List String
    , id : String
    , name : String
    }


type alias BlueprintInfo =
    { name : String
    , author : String
    , instanceNumber : Int
    , id: String
    }
