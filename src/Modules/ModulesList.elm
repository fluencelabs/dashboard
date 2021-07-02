module Modules.ModulesList exposing (..)

import Array exposing (Array)
import Cache
import Components.Spinner
import Dict
import Html exposing (Html, div)
import Modules.ModuleTile
import Palette exposing (classes)
import Set



-- model


type alias Model =
    List Modules.ModuleTile.Model


fromCache : Cache.Model -> Model
fromCache cache =
    let
        numberOfUsages id =
            Dict.get id cache.blueprintsByModuleHash |> Maybe.withDefault Array.empty |> Array.length
    in
    cache.modulesByHash
        |> Dict.values
        |> List.map
            (\x ->
                { hash = x.hash
                , name = x.name
                , numberOfUsages = numberOfUsages x.hash
                }
            )



-- view


view : Model -> Html msg
view model =
    let
        finalView =
            if List.isEmpty model then
                Components.Spinner.view

            else
                List.map Modules.ModuleTile.view model
    in
    div [ classes "cf" ] finalView
