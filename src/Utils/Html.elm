module Utils.Html exposing (..)

import Html
import Html.Attributes exposing (classList)


textOrBsp : String -> String
textOrBsp text =
    if text == "" then
        String.fromChar (Char.fromCode 0xA0)

    else
        text


classes : String -> Html.Attribute msg
classes cls =
    classList <|
        List.map (\s -> ( s, True )) <|
            String.split " " cls
