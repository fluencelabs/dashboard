module Services.View exposing (..)

import Blueprints.Model exposing (Blueprint)
import Dict exposing (Dict)
import Html exposing (Html)
import Model exposing (Model, PeerData)
import Palette exposing (classes)
import Services.Model exposing (Service, ServiceInfo)
import Utils.Utils exposing (instancesText)


view : Model -> Html msg
view model =
    let
        allBps = getBlueprintsToServices model.discoveredPeers
        info = (Dict.values allBps) |> List.map (\(bp, servicesByPeers) -> {name = bp.name, author = "Fluence Labs", instanceNumber = List.length (servicesByPeers |> List.map(\(_, s) -> s) |> List.concat)})
        servicesView =
            List.map viewService info
    in
    Html.div [ classes "cf ph2-ns" ] servicesView


viewService : ServiceInfo -> Html msg
viewService service =
    Html.div [ classes "fl w-third-ns pa2" ]
        [ Html.div [ classes "fl w-100 br2 ba solid ma2 pa3" ]
            [ Html.div [ classes "w-100 mb2 b" ] [ Html.text service.name ]
            , Html.div [ classes "w-100 mb4" ] [ Html.text ("By " ++ service.author) ]
            , Html.div [ classes "w-100" ] [ instancesText service.instanceNumber ]
            ]
        ]

--                                       bpId           peerId
getBlueprintsToServices : Dict String PeerData -> Dict String (Blueprint, (List (String, List Service)))
getBlueprintsToServices peerData =
    let
            peerDatas = Dict.toList peerData
            allBlueprints = peerDatas |> List.map (\(_, pd) -> pd.blueprints |> List.map (\bp -> bp)) |> List.concat
            bpsToServices = allBlueprints |> List.map (\bp -> (bp.id, (bp, getServicesByBlueprintId peerData bp.id))) |> Dict.fromList
        in
            bpsToServices

getServicesByBlueprintId : Dict String PeerData -> String -> List (String, List Service)
getServicesByBlueprintId peerData bpId =
    let
            list = Dict.toList peerData
            found = list |> List.map (\(peer, pd) -> (peer, (filterServicesByBlueprintId bpId pd)))
            filtered = found |> List.filter (\(_, services) -> not (List.isEmpty services))
        in
            filtered

filterServicesByBlueprintId : String -> PeerData -> List Service
filterServicesByBlueprintId blueprintId peerData =
    peerData.services |> List.filter (\s -> s.blueprint_id == blueprintId)
