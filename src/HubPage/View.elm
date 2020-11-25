module HubPage.View exposing (..)

import Html exposing (Html)
import HubPage.Model exposing (Model)
import HubPage.Msg exposing (Msg)
import Modules.Model exposing (ModuleInfo)
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


modulesExample : List ModuleInfo
modulesExample =
    [ { name = "sqlite3", instanceNumber = 2 }
    , { name = "ipfs_adapter", instanceNumber = 3 }
    , { name = "mariadb_adapter", instanceNumber = 5 }
    , { name = "chat_history", instanceNumber = 1 }
    , { name = "user_list", instanceNumber = 1 }
    , { name = "basic_auth", instanceNumber = 0 }
    ]


view : Model -> Html msg
view model =
    Html.div []
        [ Services.View.view { services = servicesExample }
        , Modules.View.view { modules = modulesExample }
        ]
