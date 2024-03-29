module Services.ServiceRow exposing (Model, fromCache, view)

import Array exposing (Array)
import Cache exposing (BlueprintId, ServiceId)
import Dict exposing (Dict)
import Html exposing (..)
import Html.Attributes exposing (..)
import Palette exposing (shortHashRaw)
import Utils.Html exposing (classes)



-- module


type alias Model =
    { blueprintName : String
    , blueprintId : BlueprintId
    , serviceId : String
    , peerId : String
    , ip : String
    }


fromCache : Cache.Model -> ServiceId -> Maybe Model
fromCache cache id =
    let
        srv =
            Dict.get id cache.servicesById

        bp =
            srv |> Maybe.andThen (\x -> Dict.get x.blueprintId cache.blueprintsById)

        node =
            Dict.get id cache.nodeByServiceId
                |> Maybe.andThen (\x -> Dict.get x cache.nodes)

        res =
            srv
                |> Maybe.map
                    (\x ->
                        { blueprintName = bp |> Maybe.map .name |> Maybe.withDefault "unkown"
                        , blueprintId = bp |> Maybe.map .id |> Maybe.withDefault "unkown"
                        , serviceId = id
                        , peerId = node |> Maybe.map .peerId |> Maybe.withDefault "unkown"
                        , ip =
                            node
                                |> Maybe.andThen Cache.firstExternalAddress
                                |> Maybe.withDefault "unkown"
                        }
                    )
    in
    res



-- view


view : Model -> Html msg
view model =
    tr [ classes "table-red-row" ]
        [ td [ classes "ph3" ] [ p [ classes "ws-normal" ] [ a [ attribute "href" ("/blueprint/" ++ model.blueprintId), classes "black" ] [ text model.blueprintName ] ] ]
        , td [ classes "ph3" ] [ p [ classes "ws-normal" ] [ text model.serviceId ] ]
        , td [ classes "ph3 dn dtc-ns" ] [ p [ classes "ws-normal" ] [ text (shortHashRaw 8 model.peerId) ] ]
        , td [ classes "ph3 dn dtc-ns" ] [ p [ classes "ws-normal" ] [ text model.ip ] ]
        ]
