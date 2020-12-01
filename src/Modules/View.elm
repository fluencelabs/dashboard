module Modules.View exposing (..)

import Dict exposing (Dict)
import Html exposing (Html, div, p, span, text)
import Html.Attributes exposing (attribute)
import Model exposing (Model, PeerData)
import Modules.Model exposing (Module, ModuleShortInfo)
import Palette exposing (classes)
import Utils.Utils exposing (instancesText)


getModuleShortInfo : Model -> List ModuleShortInfo
getModuleShortInfo model =
    getAllModules model.discoveredPeers |> Dict.toList |> List.map (\( moduleName, ( moduleInfo, peers ) ) -> { moduleInfo = moduleInfo, instanceNumber = List.length peers })


getAllModules : Dict String PeerData -> Dict String ( Module, List String )
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



-- group by module name and append peers


updateDict : ( String, Module ) -> Dict String ( Module, List String ) -> Dict String ( Module, List String )
updateDict ( peer, moduleInfo ) dict =
    dict
        |> Dict.update moduleInfo.name
            (\oldM ->
                oldM
                    |> Maybe.map (\( info, peers ) -> ( info, List.append [ peer ] peers ))
                    |> Maybe.withDefault ( moduleInfo, [ peer ] )
                    |> Just
            )


view : Model -> Html msg
view modules =
    let
        modulesView =
            List.map viewService (getModuleShortInfo modules)
    in
    div [ classes "cf ph2-ns" ] modulesView


viewService : ModuleShortInfo -> Html msg
viewService moduleInfo =
    div [ classes "fl w-third-ns pa2" ]
        [ div [ attribute "href" "#", classes "fl w-100 link dim black mw5 dt hide-child ba b-black pa4 br2 solid" ]
            [ p [ classes "tl di" ] [ span [ classes "b pl2" ] [ text moduleInfo.moduleInfo.name ], span [ classes "di fr pr2" ] [ instancesText moduleInfo.instanceNumber ] ]
            ]
        ]
