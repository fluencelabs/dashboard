module Services.Model exposing (..)

type alias Argument =
    { name: String
    , argType: String }

type alias Signature =
    { arguments: List Argument
    , name: String
    , outputTypes: String
    }

type alias Module =
    { functionSignatures: List Signature

    }

type alias Interface =
    { modules: List Module

    }

type alias Service =
    { serviceId: String
    , blueprintId: String
    , interface: Interface

    }

type alias ServiceInfo =
    { name: String,
    author: String,
    instanceNumber: Int
    }

type alias Model =
    { services : List ServiceInfo
    }