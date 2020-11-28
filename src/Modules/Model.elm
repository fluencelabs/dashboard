module Modules.Model exposing (..)


import Dict exposing (Dict)
import Model exposing (Model, PeerData)
type alias ModuleShortInfo =
    { name : String
    , instanceNumber : Int
    }

getModuleShortInfo : Model -> List ModuleShortInfo
getModuleShortInfo model =
    getAllModules model.discoveredPeers |> Dict.toList |> List.map (\(moduleName, peers) -> {name = moduleName, instanceNumber = List.length peers})

getAllModules : Dict String PeerData -> Dict String (List String)
getAllModules peerData =
    let
        peerDatas = Dict.toList peerData
        allModules = peerDatas |> List.map (\(peer, pd) -> pd.modules |> List.map (\ms -> (peer, ms))) |> List.concat
        peersByModuleName = allModules |> List.foldr updateDict Dict.empty
    in
        peersByModuleName

updateDict : (String, String) -> Dict String (List String) -> Dict String (List String)
updateDict (peer, moduleName) dict =
    dict |> Dict.update moduleName (\oldM -> oldM |> Maybe.map (List.append [peer]) |> Maybe.withDefault [peer] |> Just)
