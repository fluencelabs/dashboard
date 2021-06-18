module Service.Model exposing (..)


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


type alias Service =
    { id : String
    , blueprint_id : String
    , owner_id : String
    , interface : Maybe Interface
    }


setInterface : Interface -> Service -> Service
setInterface interface service =
    { service | interface = Just interface }
