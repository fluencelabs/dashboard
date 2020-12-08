module View exposing (view)

{-| Copyright 2020 Fluence Labs Limited

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

-}

import Browser exposing (Document, UrlRequest(..))
import Html exposing (Html, a, div, header, img, p, text)
import Html.Attributes exposing (attribute, style)
import Model exposing (Model, Route(..))
import Msg exposing (..)
import Palette exposing (classes)
import Route exposing (routeView)


view : Model -> Document Msg
view model =
    { title = title model, body = [ body model ] }


title : Model -> String
title _ =
    "Fluence Network Dashboard"


body : Model -> Html Msg
body model =
    layout <|
        List.concat
            [ [ header [ classes "w-100" ]
                    [ div [ classes "w-100 fl ph2 pv3 pb1 bg-white one-edge-shadow" ]
                        [ div [ classes "mw8-ns center ph3"]
                            [ div [ classes "fl mv1 pl3", style "max-width" "114px" ]
                                [ a [ attribute "href" "/" ]
                                    [ img [ classes "v-mid dib mw-100 h-auto", attribute "src" "/images/logo_new.svg" ] []
                                    ]
                                ]
                            , div [ classes "fl pl5 h-100" ] [ p [ classes "h-100 mv3 fw4 v-mid" ] [ text "Developer Hub" ] ]
                            ]
                        ]
                    ]
              ]
            , [ div [ classes "mw8-ns center w-100 pa4 pt3 mt4" ] [ routeView model model.page ] ]
            ]


layout : List (Html Msg) -> Html Msg
layout elms =
    div [ classes "center w-100" ]
        [ div [ classes "fl w-100" ]
            ([]
                ++ elms
            )
        ]
