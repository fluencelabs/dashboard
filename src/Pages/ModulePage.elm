module Pages.ModulePage exposing (Model, view)

import Dict exposing (Dict)
import Html exposing (Html, a, article, div, span, text)
import Html.Attributes exposing (attribute, property)
import Palette exposing (classes, redFont)



-- model


type alias Model =
    { name : String
    , id : String
    , author : String
    , authorPeerId : String
    , description : String
    , website : String
    }



-- view


view : Model -> Html msg
view model =
    div [] []
