module Blueprints.BlueprintsList exposing (Model, fromCache, view)

import Blueprints.BlueprintTile
import Cache
import Components.Spinner
import Dict exposing (Dict)
import Html exposing (Html, div)
import Palette exposing (classes)



-- model


type alias Model =
    List Blueprints.BlueprintTile.Model


fromCache : Cache.Model -> Model
fromCache cache =
    let
        getRelatedBps id =
            cache.services
                |> Dict.toList
                |> List.map Tuple.second
                |> List.filter (\x -> x.blueprint_id == id)
    in
    cache.blueprints
        |> Dict.values
        |> List.map
            (\x ->
                { name = x.name
                , author = "Fluence Labs"
                , numberOfInstances = getRelatedBps x.id |> List.length
                , id = x.id
                }
            )



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
                Components.Spinner.view

            else
                res
    in
    div [ classes "cf" ] finalView
