module Msg exposing (..)

import Url
import Browser exposing (UrlRequest)
import Port

type Msg = NoOp
    | UrlChange Url.Url
    | Request UrlRequest
    | Event Port.ReceiveEvent
    | RelayChanged String
    | Click
