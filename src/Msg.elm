module Msg exposing (..)

import Browser exposing (UrlRequest)
import Port
import Spinner
import Url


type Msg
    = NoOp
    | UrlChanged Url.Url
    | LinkClicked UrlRequest
    | AquamarineEvent Port.ReceiveEvent
    | RelayChanged String
    | ToggleInterface String
    | SpinnerMsg Spinner.Msg
    | Reload
