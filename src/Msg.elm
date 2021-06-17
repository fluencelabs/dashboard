module Msg exposing (..)

import Browser exposing (UrlRequest)
import Port
import Url


type Msg
    = NoOp
    | UrlChanged Url.Url
    | LinkClicked UrlRequest
    | CollectPeerInfo Port.CollectPeerInfo
    | CollectServiceInterface Port.CollectServiceInterface
    | RelayChanged String
    | ToggleInterface String
    | Reload
