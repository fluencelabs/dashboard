module Services.ServicesTable exposing (Model, fromCache, view)

import Cache exposing (ServiceId)
import Html exposing (..)
import Html.Attributes exposing (..)
import Maybe.Extra as Maybe
import Palette exposing (classes)
import Services.ServiceRow



-- model


type alias Model =
    List Services.ServiceRow.Model


fromCache : Cache.Model -> List ServiceId -> Model
fromCache cache services =
    services
        |> List.map (Services.ServiceRow.fromCache cache)
        |> Maybe.values



-- view


view : Model -> Html msg
view model =
    div [ classes "pa1 bg-white br3 overflow-auto" ]
        [ div [ classes "mw8-ns pa2 " ]
            [ table [ classes "f6 w-100 center ws-normal-ns", attribute "cellspacing" "0" ]
                [ thead []
                    [ tr [ classes "" ]
                        [ th [ classes "fw5 tl pa3 gray-font" ] [ text "BLUEPRINT" ]
                        , th [ classes "fw5 tl pa3 gray-font" ] [ text "SERVICE ID" ]
                        , th [ classes "fw5 tl pa3 gray-font dn dtc-ns" ] [ text "NODE" ]
                        , th [ classes "fw5 tl pa3 gray-font dn dtc-ns" ] [ text "MULTIADDR" ]
                        ]
                    ]
                , tbody [ classes "lucida" ] (model |> List.map Services.ServiceRow.view)
                ]
            ]
        ]
