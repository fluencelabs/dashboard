module Modules.View exposing (..)

import Blueprints.Model exposing (Blueprint)
import Components.Spinner
import Dict exposing (Dict)
import Html exposing (Html, a, div, p, text)
import Html.Attributes exposing (attribute)
import Maybe.Extra
import Model exposing (Model, PeerData)
import Modules.Model exposing (Module, ModuleShortInfo)
import Palette exposing (classes)
import Service.Model exposing (Service)
import Utils.Utils exposing (instancesText)


getModuleShortInfo : Model -> List ModuleShortInfo
getModuleShortInfo model =
    let
        all =
            getAllModules model.blueprints model.modules model.modulesByHash model.discoveredPeers

        res =
            all
                |> Dict.toList
                |> List.map (\( _, ( moduleInfo, services ) ) -> { moduleInfo = moduleInfo, instanceNumber = List.length services })
    in
    res


getAllModules : Dict String Blueprint -> Dict String Module -> Dict String Module -> Dict String PeerData -> Dict String ( Module, List Service )
getAllModules blueprints modules modulesByHash peerData =
    let
        peerDatas =
            Dict.toList peerData

        allModulesByPeers =
            peerDatas |> List.map (\( _, pd ) -> pd.modules |> List.map (\ms -> ( pd, ms, Maybe.withDefault "" (Maybe.map .hash (modules |> Dict.get ms)) ))) |> List.concat

        peersByModuleName =
            allModulesByPeers |> List.foldr (updateDict blueprints modules modulesByHash) Dict.empty
    in
    peersByModuleName



-- group by module name and append peers


updateDict : Dict String Blueprint -> Dict String Module -> Dict String Module -> ( PeerData, String, String ) -> Dict String ( Module, List Service ) -> Dict String ( Module, List Service )
updateDict blueprints modules modulesByHash ( peerData, moduleName, moduleHash ) dict =
    let
        filterByHash =
            \hash -> \list -> list |> List.filter (filterByModuleHash blueprints hash)

        filterByName =
            \name -> \list -> list |> List.filter (filterByModuleName blueprints name)

        allModules =
            Dict.union modules modulesByHash

        dictNames =
            dict
                |> Dict.update moduleName
                    (\oldM ->
                        Maybe.Extra.or
                            (oldM |> Maybe.map (\( info, services ) -> ( info, List.concat [ filterByHash moduleHash peerData.services, filterByName info.name peerData.services, services ] )))
                            (Dict.get moduleName allModules |> Maybe.map (\m -> ( m, List.append (filterByHash moduleHash peerData.services) (filterByName m.name peerData.services) )))
                    )
    in
    dictNames


filterByModuleName : Dict String Blueprint -> String -> (Service -> Bool)
filterByModuleName bps moduleName =
    let
        names =
            \bp ->
                bp.dependencies
                    |> List.map Utils.Utils.hashValueFromString

        check =
            Maybe.map (\bp -> names bp |> List.member moduleName)

        filter =
            \s -> bps |> Dict.get s.blueprint_id |> check |> Maybe.withDefault False
    in
    filter


filterByModuleHash : Dict String Blueprint -> String -> (Service -> Bool)
filterByModuleHash bps moduleHash =
    let
        hashes =
            \bp ->
                bp.dependencies
                    |> List.map Utils.Utils.hashValueFromString

        check =
            Maybe.map (\bp -> hashes bp |> List.member moduleHash)

        filter =
            \s -> bps |> Dict.get s.blueprint_id |> check |> Maybe.withDefault False
    in
    filter


view : Model -> Html msg
view model =
    let
        info =
            getModuleShortInfo model

        modulesView =
            List.map viewService info

        finalView =
            if List.isEmpty modulesView then
                Components.Spinner.view

            else
                modulesView
    in
    div [ classes "cf" ] finalView


viewService : ModuleShortInfo -> Html msg
viewService moduleInfo =
    div [ classes "fl w-100 w-third-ns pr3" ]
        [ a
            [ attribute "href" ("/module/" ++ moduleInfo.moduleInfo.name)
            , classes "fl w-100 bg-white black mw6 mr2 mb3 hide-child pa2 element-box ba b--white pl3"
            ]
            [ p [ classes "tl di" ]
                [ div [ classes "fl b w-100 mb1 fw5 overflow-hidden" ]
                    [ text moduleInfo.moduleInfo.name ]
                , div [ classes "fl w-100 mt1 lucida gray-font2" ] [ instancesText moduleInfo.instanceNumber ]
                ]
            ]
        ]
