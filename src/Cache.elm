module Cache exposing (..)

import AquaPorts.CollectPeerInfo exposing (Blueprint, PeerInfo)
import AquaPorts.CollectServiceInterface exposing (ServiceInterface)
import Dict exposing (Dict)



-- model


type alias Model =
    { blueprints : Dict String Blueprint }


init : Model
init =
    { blueprints = Dict.empty }



-- msg


type Msg
    = CollectPeerInfo PeerInfo
    | CollectServiceInterface ServiceInterface



-- update


update : Model -> Msg -> Model
update model msg =
    case msg of
        CollectPeerInfo { peerId, blueprints } ->
            let
                newBlueprints =
                    blueprints |> Maybe.withDefault [] |> List.map (\b -> ( b.id, b )) |> Dict.fromList
            in
            { model | blueprints = Dict.union model.blueprints newBlueprints }

        CollectServiceInterface _ ->
            model
