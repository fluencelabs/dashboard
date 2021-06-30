port module AquaPorts.CollectServiceInterface exposing (..)


type alias SignatureDto =
    { arguments : List (List String)
    , name : String
    , output_types : List String
    }


type alias FieldDto =
    { name : String
    , ty : String
    }


type alias RecordDto =
    { fields : List FieldDto
    , id : Int
    , name : String
    }


type alias InterfaceDto =
    { function_signatures : List SignatureDto
    , record_types : List RecordDto
    }


type alias ServiceInterfaceDto =
    { peer_id : String
    , service_id : String
    , interface : InterfaceDto
    }


port collectServiceInterface : (ServiceInterfaceDto -> msg) -> Sub msg
