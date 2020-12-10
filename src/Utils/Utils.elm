module Utils.Utils exposing (..)

import Html exposing (Html)


instancesText : Int -> Html msg
instancesText num =
    let
        strNum =
            String.fromInt num
    in
    if num == 1 then
        Html.text (strNum ++ " instance")

    else
        Html.text (strNum ++ " instances")


servicesText : Int -> Html msg
servicesText num =
    let
        strNum =
            String.fromInt num
    in
    if num == 1 then
        Html.text (strNum ++ " service")

    else
        Html.text (strNum ++ " services")
