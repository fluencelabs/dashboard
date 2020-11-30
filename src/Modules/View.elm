module Modules.View exposing (..)

import Dict exposing (Dict)
import Html exposing (Html, div, p, span, text)
import Model exposing (Model, PeerData)
import Modules.Model exposing (ModuleShortInfo)
import Palette exposing (classes)
import Utils.Utils exposing (instancesText)


getModuleShortInfo : Model -> List ModuleShortInfo
getModuleShortInfo model =
    getAllModules model.discoveredPeers |> Dict.toList |> List.map (\( moduleName, peers ) -> { name = moduleName, instanceNumber = List.length peers })


getAllModules : Dict String PeerData -> Dict String (List String)
getAllModules peerData =
    let
        peerDatas =
            Dict.toList peerData

        allModules =
            peerDatas |> List.map (\( peer, pd ) -> pd.modules |> List.map (\ms -> ( peer, ms ))) |> List.concat

        peersByModuleName =
            allModules |> List.foldr updateDict Dict.empty
    in
    peersByModuleName


updateDict : ( String, String ) -> Dict String (List String) -> Dict String (List String)
updateDict ( peer, moduleName ) dict =
    dict |> Dict.update moduleName (\oldM -> oldM |> Maybe.map (List.append [ peer ]) |> Maybe.withDefault [ peer ] |> Just)


view : Model -> Html msg
view modules =
    let
        modulesView =
            List.map viewService (getModuleShortInfo modules)
    in
    div [ classes "cf ph2-ns" ] modulesView


viewService : ModuleShortInfo -> Html msg
viewService service =
    div [ classes "fl w-third-ns pa2" ]
        [ div [ classes "fl w-100 br2 ba solid pa2 mh2" ]
            [ p [ classes "tl di" ] [ span [ classes "b pl2" ] [ text service.name ], span [ classes "di fr pr2" ] [ instancesText service.instanceNumber ] ]
            ]
        ]
