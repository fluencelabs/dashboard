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
import Html exposing (Html, div, header, text)
import Html.Attributes exposing (class, classList)
import Html.Events exposing (onClick)
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
    let
        a =
            1

        url =
            model.url

        newUrl =
            { url | path = "/hub" }
    in
    layout <|
        List.concat
            [ [ header [ classes "w-100 bt bb b--black-10" ] [ routeView model (Page "hub") ] ]
                ++ [ header [ classes "w-100 bt bb b--black-10" ] [ routeView model (Page "module") ] ]
                ++ [ header [ classes "w-100 bt bb b--black-10", onClick (Click "get_services") ] [ text "GET SERVICES" ] ]
                ++ [ header [ classes "w-100 bt bb b--black-10", onClick (Click "get_modules") ] [ text "GET MODULES" ] ]
                ++ [ header [ classes "w-100 bt bb b--black-10", onClick (Click "get_identify") ] [ text "GET IDENTIFY" ] ]
            ]


layout : List (Html Msg) -> Html Msg
layout elms =
    div [ classes "mw9 center w-70" ]
        [ div [ classes "fl w-100 pa2" ]
            ([]
                ++ elms
            )
        ]
