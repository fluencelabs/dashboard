module Utils.Html exposing (..)


textOrBsp : String -> String
textOrBsp text =
    if text == "" then
        String.fromChar (Char.fromCode 0xA0)

    else
        text
