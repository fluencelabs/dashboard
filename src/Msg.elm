module Msg exposing (..)

import Browser exposing (UrlRequest)
import Cache
import Url


type Msg
    = NoOp
    | UrlChanged Url.Url
    | LinkClicked UrlRequest
    | RelayChanged String
    | ToggleInterface String
    | Reload
    | Cache Cache.Msg
