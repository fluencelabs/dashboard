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
import Element exposing (Element, centerX, column, el, height, inFront, padding, paragraph, row, spacing, text)
import Element.Font as Font
import Html exposing (Html)
import Ions.Background as BG
import Ions.Font as F
import Ions.Size as S
import Model exposing (Model)
import Msg exposing (..)
import Palette exposing (fillWidth, layoutBlock, limitLayoutWidth, pSpacing)
import Screen.Model as Screen


view : Model -> Document Msg
view model =
    { title = title model, body = [ body model ] }


title : Model -> String
title m =
    "Admin"


body : Model -> Html Msg
body model =
    layout model.screen <|
        List.concat
            [
            ]


header : Screen.Model -> List (Element Msg)
header screenI =
    [ column (layoutBlock screenI ++ [ spacing (S.baseRem 1.125) ])
        [ row
            [ fillWidth ]
            [ paragraph [ Font.italic, F.gray, pSpacing ] <|
                [ text "Fluence Admin" ]
            ]
        , el [ height <| Element.px <| S.baseRem 0.5 ] Element.none
        ]
    ]


layout : Screen.Model -> List (Element Msg) -> Html Msg
layout screen elms =
    Element.layout
        [ F.size6
        , F.sansSerif
        , Element.padding (S.baseRem 1)
        , Element.centerX
        , BG.lightGray
        , inFront <| column [ fillWidth, centerX, BG.white, limitLayoutWidth ] (header screen)
        ]
    <|
        Element.column
            [ Element.centerX
            , fillWidth
            , limitLayoutWidth
            , BG.white
            , padding 20
            ]
            elms
