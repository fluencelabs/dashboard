module Services.ServiceRow exposing (Model, view)

import Cache exposing (BlueprintId)
import Html exposing (..)
import Html.Attributes exposing (..)
import Palette exposing (classes, shortHashRaw)



-- module


type alias Model =
    { blueprintName : String
    , blueprintId : BlueprintId
    , serviceId : String
    , peerId : String
    , ip : String
    }



-- view


view : Model -> Html msg
view model =
    tr [ classes "table-red-row" ]
        [ td [ classes "ph3" ] [ p [ classes "ws-normal" ] [ a [ attribute "href" ("/blueprint/" ++ model.blueprintId), classes "black" ] [ text model.blueprintName ] ] ]
        , td [ classes "ph3" ] [ p [ classes "ws-normal" ] [ text model.serviceId ] ]
        , td [ classes "ph3 dn dtc-ns" ] [ p [ classes "ws-normal" ] [ text (shortHashRaw 8 model.peerId) ] ]
        , td [ classes "ph3 dn dtc-ns" ] [ p [ classes "ws-normal" ] [ text model.ip ] ]
        ]
