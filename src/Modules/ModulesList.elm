module Modules.ModulesList exposing (..)

import Cache
import Components.Spinner
import Dict
import Html exposing (Html, div)
import Modules.ModuleTile
import Utils.Html exposing (classes)



-- model


type alias Model =
    List Modules.ModuleTile.Model


fromCache : Cache.Model -> Model
fromCache cache =
    cache.modulesByHash
        |> Dict.values
        |> List.map
            (\x ->
                { hash = x.hash
                , name = x.name
                , numberOfUsages = Cache.getServicesThatUseModule cache x.hash |> List.length
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
