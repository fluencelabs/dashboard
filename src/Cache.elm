module Cache exposing (..)

import AquaPorts.CollectPeerInfo exposing (BlueprintDto, ModuleDto, PeerDto, ServiceDto)
import AquaPorts.CollectServiceInterface exposing (ServiceInterfaceDto)
import Array exposing (Array)
import Blueprints.Model exposing (Blueprint)
import Dict exposing (Dict, values)
import Dict.Extra as Dict
import Html exposing (b)
import Set exposing (Set)



-- model


type alias BlueprintId =
    String


type alias ServiceId =
    String


type alias Hash =
    String


extractHash : String -> Hash
extractHash str =
    str
        |> String.split ":"
        |> Array.fromList
        |> Array.get 1
        |> Maybe.withDefault ""


type alias Module =
    { hash : Hash
    , name : String
    , interfaces : Maybe (List Never)
    }


moduleFromDto : ModuleDto -> Module
moduleFromDto dto =
    { name = dto.name
    , hash = dto.hash
    , interfaces = Nothing
    }


type alias Blueprint =
    { id : BlueprintId
    , name : String
    , dependencies : Set Hash
    }


blueprintFromDto : BlueprintDto -> Blueprint
blueprintFromDto bp =
    { id = bp.id
    , dependencies = bp.dependencies |> List.map extractHash |> Set.fromList
    , name = bp.name
    }


type alias Service =
    { id : String
    , blueprintId : BlueprintId
    , ownerId : String
    }


serviceFromDto : ServiceDto -> Service
serviceFromDto s =
    { id = s.id
    , blueprintId = s.blueprint_id
    , ownerId = s.owner_id
    }


type alias PeerId =
    String


type alias Multiaddress =
    String


type alias Node =
    { peerId : PeerId
    , externalAddresses : Array Multiaddress
    , services : Array ServiceId
    , blueprints : Array BlueprintId
    }


firstExternalAddress : Node -> Maybe Multiaddress
firstExternalAddress node =
    Array.get 0 node.externalAddresses


type alias Model =
    { blueprintsById : Dict BlueprintId Blueprint
    , servicesById : Dict ServiceId Service
    , modulesByHash : Dict Hash Module
    , blueprintsByModuleHash : Dict Hash (Array BlueprintId)
    , servicesByBlueprintId : Dict BlueprintId (Array ServiceId)
    , nodeByServiceId : Dict ServiceId PeerId
    , nodeByBlueprintId : Dict BlueprintId PeerId
    , nodes : Dict PeerId Node
    }


init : Model
init =
    { blueprintsById = Dict.empty
    , servicesById = Dict.empty
    , modulesByHash = Dict.empty
    , blueprintsByModuleHash = Dict.empty
    , servicesByBlueprintId = Dict.empty
    , nodeByServiceId = Dict.empty
    , nodeByBlueprintId = Dict.empty
    , nodes = Dict.empty
    }



-- msg


type Msg
    = CollectPeerInfo PeerDto
    | CollectServiceInterface ServiceInterfaceDto



-- update


update : Model -> Msg -> Model
update model msg =
    case msg of
        CollectPeerInfo { peerId, blueprints, services, identify, modules } ->
            let
                newBlueprints =
                    blueprints |> Maybe.withDefault [] |> List.map blueprintFromDto |> Dict.fromListBy (\x -> x.id)

                newServices =
                    services |> Maybe.withDefault [] |> List.map serviceFromDto |> Dict.fromListBy (\x -> x.id)

                newModules =
                    modules |> Maybe.withDefault [] |> List.map moduleFromDto |> Dict.fromListBy (\x -> x.hash)

                resultBlueprints =
                    Dict.union newBlueprints model.blueprintsById

                resultServices =
                    Dict.union newServices model.servicesById

                resultServicesByBlueprintId =
                    resultServices
                        |> Dict.values
                        |> Dict.groupBy (\x -> x.blueprintId)
                        |> Dict.map (\k -> \v -> v |> List.map (\listVal -> listVal.id) |> Array.fromList)

                externalAddresses =
                    identify
                        |> Maybe.map (\x -> x.external_addresses)
                        |> Maybe.withDefault []
                        |> Array.fromList

                newNode =
                    { peerId = peerId
                    , externalAddresses = externalAddresses
                    , services = Dict.keys newServices |> Array.fromList
                    , blueprints = Dict.keys newBlueprints |> Array.fromList
                    }

                bpMyModuleHash =
                    Dict.values resultBlueprints
                        |> List.foldl
                            (\bp ->
                                \acc ->
                                    bp.dependencies
                                        |> Set.foldl
                                            (\hash ->
                                                Dict.insertDedupe (\l1 -> \l2 -> l1 ++ l2) hash [ bp.id ]
                                            )
                                            acc
                            )
                            Dict.empty
                        |> Dict.map (\k -> \v -> Array.fromList v)
            in
            { model
                | blueprintsById = resultBlueprints
                , servicesById = resultServices
                , servicesByBlueprintId = resultServicesByBlueprintId
                , modulesByHash = Dict.union model.modulesByHash newModules
                , blueprintsByModuleHash = bpMyModuleHash
                , nodes = Dict.insert newNode.peerId newNode model.nodes
                , nodeByServiceId = Dict.union model.nodeByServiceId (Dict.map (\x -> \_ -> peerId) newServices)
                , nodeByBlueprintId = Dict.union model.nodeByBlueprintId (Dict.map (\x -> \_ -> peerId) newBlueprints)
            }

        CollectServiceInterface _ ->
            model
