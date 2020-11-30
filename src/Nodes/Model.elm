module Nodes.Model exposing (..)


type alias Identify =
    { external_addresses : List String }


emptyIdentify : Identify
emptyIdentify =
    { external_addresses = [] }
