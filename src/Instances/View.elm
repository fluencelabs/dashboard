module Instances.View exposing (..)

import Html exposing (Html, div, table, tbody, td, text, th, thead, tr)
import Html.Attributes exposing (attribute)
import Instances.Model exposing (Instance)
import Model exposing (Model)
import Palette exposing (classes)


view : Model -> Html msg
view model =
    let
        instances =
            [ { name = "SQLite", instance = "efrer3434g", peerId = "kljn35kfj4n5kjgn4k5jgn45kj", ip = "123.123.123.123" }
            , { name = "SQLite", instance = "efrer3434g", peerId = "kljn35kfj4n5kjgn4k5jgn45kj", ip = "123.123.123.123" }
            , { name = "SQLite", instance = "efrer3434g", peerId = "kljn35kfj4n5kjgn4k5jgn45kj", ip = "123.123.123.123" }
            , { name = "SQLite", instance = "efrer3434g", peerId = "kljn35kfj4n5kjgn4k5jgn45kj", ip = "123.123.123.123" }
            ]
    in
    viewTable instances


viewTable : List Instance -> Html msg
viewTable instances =
    div [ classes "pa4" ]
        [ div [ classes "overflow-auto" ]
            [ table [ classes "f6 w-100 mw8 center", attribute "cellspacing" "0" ]
                [ thead []
                    [ tr [ classes "stripe-dark" ]
                        [ th [ classes "fw6 tl pa3 bg-white" ] [ text "SERVICE" ]
                        , th [ classes "fw6 tl pa3 bg-white" ] [ text "INSTANCE" ]
                        , th [ classes "fw6 tl pa3 bg-white" ] [ text "NODE" ]
                        , th [ classes "fw6 tl pa3 bg-white" ] [ text "IP" ]
                        ]
                    ]
                , tbody [ classes "lh-copy" ] (instances |> List.map viewInstance)
                ]
            ]
        ]


viewInstance : Instance -> Html msg
viewInstance instance =
    tr [ classes "stripe-dark" ]
        [ td [ classes "pa3" ] [ text instance.name ]
        , td [ classes "pa3" ] [ text instance.instance ]
        , td [ classes "pa3" ] [ text instance.peerId ]
        , td [ classes "pa3" ] [ text instance.ip ]
        ]
