module Modules.View exposing (..)

import Blueprints.Model exposing (Blueprint)
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
    getAllModules model.blueprints model.modules model.discoveredPeers
        |> Dict.toList
        |> List.map (\( _, ( moduleInfo, services ) ) -> { moduleInfo = moduleInfo, instanceNumber = List.length services })


getAllModules : Dict String Blueprint -> Dict String Module -> Dict String PeerData -> Dict String ( Module, List Service )
getAllModules blueprints modules peerData =
    let
        peerDatas =
            Dict.toList peerData

        allModulesByPeers =
            peerDatas |> List.map (\( _, pd ) -> pd.modules |> List.map (\ms -> ( pd, ms ))) |> List.concat

        peersByModuleName =
            allModulesByPeers |> List.foldr (updateDict blueprints modules) Dict.empty
    in
    peersByModuleName



-- group by module name and append peers


updateDict : Dict String Blueprint -> Dict String Module -> ( PeerData, String ) -> Dict String ( Module, List Service ) -> Dict String ( Module, List Service )
updateDict blueprints modules ( peerData, moduleName ) dict =
    let
        filter =
            \name -> \list -> list |> List.filter (filterByModuleName blueprints name)
    in
    dict
        |> Dict.update moduleName
            (\oldM ->
                Maybe.Extra.or
                    (oldM |> Maybe.map (\( info, services ) -> ( info, List.append (filter info.name peerData.services) services )))
                    (Dict.get moduleName modules |> Maybe.map (\m -> ( m, filter m.name peerData.services )))
            )


filterByModuleName : Dict String Blueprint -> String -> (Service -> Bool)
filterByModuleName bps moduleName =
    let
        check =
            Maybe.map (\bp -> bp.dependencies |> List.member moduleName)

        filter =
            \s -> bps |> Dict.get s.blueprint_id |> check |> Maybe.withDefault False
    in
    filter


view : Model -> Html msg
view modules =
    let
        info =
            getModuleShortInfo modules

        modulesView =
            List.map viewService info
    in
    div [ classes "cf" ] modulesView


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
