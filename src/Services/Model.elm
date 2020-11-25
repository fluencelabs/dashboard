module Services.Model exposing (..)

type alias Service =
    { name: String,
    author: String,
    instanceNumber: Int
    }

type alias Model =
    { services : List Service
    }