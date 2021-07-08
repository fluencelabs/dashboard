module RoutePage exposing (Model, fromCache, view)

import Cache
import Components.Spinner
import Dict
import Html exposing (Html, div, text)
import Pages.BlueprintPage
import Pages.Hub
import Pages.ModulePage
import Pages.NodesPage
import Route exposing (Route(..))



-- model


type Model
    = Hub Pages.Hub.Model
    | Nodes Pages.NodesPage.Model
    | Blueprint (Maybe Pages.BlueprintPage.Model)
    | Module (Maybe Pages.ModulePage.Model)
    | Unknown String


fromCache : Route.Route -> Cache.Model -> Model
fromCache route cache =
    case route of
        Route.Home ->
            Hub (Pages.Hub.fromCache cache)

        Route.Hub ->
            Hub (Pages.Hub.fromCache cache)

        Route.Nodes ->
            Nodes (Pages.NodesPage.fromCache cache)

        Route.Blueprint id ->
            Blueprint (Pages.BlueprintPage.fromCache cache id)

        Route.Module moduleName ->
            let
                hash =
                    Dict.get moduleName cache.modulesByName

                m =
                    Maybe.andThen (Pages.ModulePage.fromCache cache) hash
            in
            Module m

        Route.Peer peer ->
            Unknown peer

        Route.Unknown s ->
            Unknown s



-- view


view : Model -> Html msg
view model =
    case model of
        Hub m ->
            Pages.Hub.view m

        Nodes m ->
            Pages.NodesPage.view m

        Blueprint m ->
            case m of
                Just mm ->
                    Pages.BlueprintPage.view mm

                Nothing ->
                    div []
                        Components.Spinner.view

        Module m ->
            case m of
                Just mm ->
                    Pages.ModulePage.view mm

                Nothing ->
                    div []
                        Components.Spinner.view

        Unknown s ->
            text ("Not found: " ++ s)
