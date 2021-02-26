module Service.Model exposing (..)


type alias Signature =
    { arguments : List (List String)
    , name : String
    , output_types : List String
    }


type alias Record =
    { fields : List (List String)
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

    --, interface : Interface
    , owner_id : String
    }
