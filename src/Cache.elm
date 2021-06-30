module Cache exposing (..)

import AquaPorts.CollectPeerInfo exposing (BlueprintDto, PeerDto, ServiceDto)
import AquaPorts.CollectServiceInterface exposing (ServiceInterfaceDto)
import Array exposing (Array)
import Blueprints.Model exposing (Blueprint)
import Dict exposing (Dict)
import Dict.Extra as Dict



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


type alias Blueprint =
    { id : BlueprintId
    , name : String
    , dependencies : Array Hash
    }


blueprintFromDto : BlueprintDto -> Blueprint
blueprintFromDto bp =
    { id = bp.id
    , dependencies = bp.dependencies |> List.map extractHash |> Array.fromList
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


type alias Model =
    { blueprintsById : Dict BlueprintId Blueprint
    , servicesById : Dict ServiceId Service
    , servicesByBlueprintId : Dict BlueprintId (Array ServiceId)
    }


init : Model
init =
    { blueprintsById = Dict.empty
    , servicesById = Dict.empty
    , servicesByBlueprintId = Dict.empty
    }



-- msg


type Msg
    = CollectPeerInfo PeerDto
    | CollectServiceInterface ServiceInterfaceDto



-- update


update : Model -> Msg -> Model
update model msg =
    case msg of
        CollectPeerInfo { peerId, blueprints, services } ->
            let
                newBlueprints =
                    blueprints |> Maybe.withDefault [] |> List.map blueprintFromDto |> Dict.fromListBy (\x -> x.id)

                newServices =
                    services |> Maybe.withDefault [] |> List.map serviceFromDto |> Dict.fromListBy (\x -> x.id)

                resultBlueprints =
                    Dict.union newBlueprints model.blueprintsById

                resultServices =
                    Dict.union newServices model.servicesById

                resultServicesByBlueprintId =
                    resultServices
                        |> Dict.values
                        |> Dict.groupBy (\x -> x.blueprintId)
                        |> Dict.map (\k -> \v -> v |> List.map (\listVal -> listVal.id) |> Array.fromList)
            in
            { model
                | blueprintsById = resultBlueprints
                , servicesById = resultServices
                , servicesByBlueprintId = resultServicesByBlueprintId
            }

        CollectServiceInterface _ ->
            model
