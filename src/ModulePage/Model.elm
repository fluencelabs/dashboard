module ModulePage.Model exposing (..)

import Services.Model exposing (Service)

type alias ModuleInfo =
    { name: String
    , id: String
    , author: String
    , authorPeerId: String
    , description: String
    , website: String
    , service: Service
    }
