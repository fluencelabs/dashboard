module Cache exposing (..)

import AquaPorts.CollectPeerInfo exposing (Blueprint, PeerInfo, Service)
import AquaPorts.CollectServiceInterface exposing (ServiceInterface)
import Dict exposing (Dict)



-- model


type alias Model =
    { blueprints : Dict String Blueprint
    , services : Dict String Service
    }


init : Model
init =
    { blueprints = Dict.empty
    , services = Dict.empty
    }



-- msg


type Msg
    = CollectPeerInfo PeerInfo
    | CollectServiceInterface ServiceInterface



-- update


update : Model -> Msg -> Model
update model msg =
    case msg of
        CollectPeerInfo { peerId, blueprints, services } ->
            let
                newBlueprints =
                    blueprints |> Maybe.withDefault [] |> List.map (\b -> ( b.id, b )) |> Dict.fromList

                newServices =
                    services |> Maybe.withDefault [] |> List.map (\s -> ( s.id, s )) |> Dict.fromList
            in
            { model
                | blueprints = Dict.union model.blueprints newBlueprints
                , services = Dict.union model.services newServices
            }

        CollectServiceInterface _ ->
            model
