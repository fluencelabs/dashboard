module Modules.View exposing (..)

import Dict exposing (Dict)
import Html exposing (Html, a, div, p, span, text)
import Html.Attributes exposing (attribute)
import Maybe.Extra
import Model exposing (Model, PeerData)
import Modules.Model exposing (Module, ModuleShortInfo)
import Palette exposing (classes)
import Utils.Utils exposing (instancesText)


getModuleShortInfo : Model -> List ModuleShortInfo
getModuleShortInfo model =
    getAllModules model.modules model.discoveredPeers |> Dict.toList |> List.map (\( moduleName, ( moduleInfo, peers ) ) -> { moduleInfo = moduleInfo, instanceNumber = List.length peers })


getAllModules : Dict String Module -> Dict String PeerData -> Dict String ( Module, List String )
getAllModules modules peerData =
    let
        peerDatas =
            Dict.toList peerData

        allModulesByPeers =
            peerDatas |> List.map (\( peer, pd ) -> pd.modules |> List.map (\ms -> ( peer, ms ))) |> List.concat

        peersByModuleName =
            allModulesByPeers |> List.foldr (updateDict modules) Dict.empty
    in
    peersByModuleName



-- group by module name and append peers


updateDict : Dict String Module -> ( String, String ) -> Dict String ( Module, List String ) -> Dict String ( Module, List String )
updateDict modules ( peer, moduleName ) dict =
    dict
        |> Dict.update moduleName
            (\oldM ->
                Maybe.Extra.or
                    (oldM |> Maybe.map (\( info, peers ) -> ( info, List.append [ peer ] peers )))
                    (Dict.get moduleName modules |> Maybe.map (\m -> ( m, [ peer ] )))
            )


view : Model -> Html msg
view modules =
    let
        info =
            getModuleShortInfo modules

        modulesView =
            List.map viewService info
    in
    div [ classes "cf ph2-ns" ] modulesView


viewService : ModuleShortInfo -> Html msg
viewService moduleInfo =
    div [ classes "fl w-third-ns pa2" ]
        [ a [ attribute "href" ("/module/" ++ moduleInfo.moduleInfo.name), classes "fl w-100 link dim black mw5 dt hide-child ba b-black pa4 br2 solid" ]
            [ p [ classes "tl di" ] [ span [ classes "b pl2" ] [ text moduleInfo.moduleInfo.name ], span [ classes "di fr pr2" ] [ instancesText moduleInfo.instanceNumber ] ]
            ]
        ]
