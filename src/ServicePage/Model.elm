module ServicePage.Model exposing (..)

import Services.Model exposing (Service)


type alias ServiceInfo =
    { name : String
    , id : String
    , author : String
    , authorPeerId : String
    , description : String
    , website : String
    , service : Service
    }
