module Msg exposing (..)

import Screen.Msg
type Msg = NoOp
    | ScreenMsg Screen.Msg.Msg
