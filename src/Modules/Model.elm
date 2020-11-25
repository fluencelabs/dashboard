module Modules.Model exposing (..)

type alias Module =
    { name: String
    , instanceNumber: Int
    }

type alias Model =
    { modules : List Module
    }