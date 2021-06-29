port module AquaPorts.CollectServiceInterface exposing (..)


type alias Signature =
    { arguments : List (List String)
    , name : String
    , output_types : List String
    }


type alias Field =
    { name : String
    , ty : String
    }


type alias Record =
    { fields : List Field
    , id : Int
    , name : String
    }


type alias Interface =
    { function_signatures : List Signature
    , record_types : List Record
    }


type alias ServiceInterface =
    { peer_id : String
    , service_id : String
    , interface : Interface
    }


port collectServiceInterface : (ServiceInterface -> msg) -> Sub msg
