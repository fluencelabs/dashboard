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

import Browser exposing (Document)
import Html exposing (Html, div, header, text)
import Html.Attributes exposing (class, classList)
import Html.Events exposing (onClick)
import Model exposing (Model)
import Msg exposing (..)
import Palette exposing (classes)


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
            [-- TODO render the view according to model.page
            ]


layout : List (Html Msg) -> Html Msg
layout elms =
    div [ classes "mw9 center" ]
        [ div [ classes "fl w-100 pa2" ]
            ([ header [ classes "w-100 bt bb b--black-10", onClick Click ] [ text "Fluence Network Dashboard" ]
             ]
                ++ elms
            )
        ]
