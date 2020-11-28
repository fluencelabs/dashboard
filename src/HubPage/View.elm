module HubPage.View exposing (..)

import Html exposing (Html)
import Model exposing (Model)
import Modules.Model exposing (ModuleShortInfo, getModuleShortInfo)
import Modules.View
import Services.Model exposing (ServiceInfo)
import Services.View


servicesExample : List ServiceInfo
servicesExample =
    [ { name = "SQLite", author = "Company Inc", instanceNumber = 2 }
    , { name = "Redis", author = "Roga Kopita", instanceNumber = 3 }
    , { name = "Chat", author = "Fluence Labs", instanceNumber = 5 }
    , { name = "Imagemagick", author = "Magic Corp", instanceNumber = 0 }
    ]


view : Model -> Html msg
view model =
    Html.div []
        [ Services.View.view { services = servicesExample }
        , Modules.View.view (getModuleShortInfo model)
        ]
