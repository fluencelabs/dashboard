module Utils.Utils exposing (..)

import Html exposing (Html)


hashValueFromString : String -> String
hashValueFromString x =
    x |> String.split ":" |> List.tail |> Maybe.andThen List.head |> Maybe.withDefault ""


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
