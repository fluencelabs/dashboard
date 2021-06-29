module Blueprints.BlueprintsList exposing (Model, view)

import Blueprints.BlueprintTile
import Components.Spinner
import Html exposing (Html, div)
import Palette exposing (classes)



-- model


type alias Model =
    List Blueprints.BlueprintTile.Model



-- view


view : Model -> Html msg
view model =
    let
        -- TODO HACK: this is a hack to filter bloat blueprints until we have a predefined list of good ones
        res =
            List.filter (\bp -> bp.numberOfInstances > 3) model
                |> List.map Blueprints.BlueprintTile.view

        finalView =
            if List.isEmpty res then
                Components.Spinner.spinner

            else
                res
    in
    div [ classes "cf" ] finalView
