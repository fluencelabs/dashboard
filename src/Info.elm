module Info exposing (..)

import Dict exposing (Dict)


type alias ModuleDescription =
    { site : String
    , description : String
    }


getSite : String -> String
getSite name =
    modulesDescription |> Dict.get name |> Maybe.map .site |> Maybe.withDefault ""


getDescription : String -> String
getDescription name =
    modulesDescription |> Dict.get name |> Maybe.map .description |> Maybe.withDefault "Awesome module without description"


modulesDescription : Dict String ModuleDescription
modulesDescription =
    Dict.fromList
        [ ( "sqlite3", { site = "https://github.com/fluencelabs/sqlite", description = "Popular embeddable database compiled to WebAssembly" } )
        , ( "Message History", { site = "https://github.com/fluencelabs/aqua-demo/tree/master/services/history", description = "Stores message log, used in the Chat application" } )
        , ( "User List", { site = "https://github.com/fluencelabs/aqua-demo/tree/master/services/user-list", description = "Basically an address book. Used in the Chat application to store chat users" } )
        , ( "redis", { site = "https://github.com/fluencelabs/redis", description = "Popular embeddable database compiled to WebAssembly" } )
        , ( "curl", { site = "https://github.com/fluencelabs/fce/tree/master/examples/url-downloader/curl", description = "Module that call 'curl' command" } )
        , ( "local_storage", { site = "https://github.com/fluencelabs/fce/tree/master/examples/url-downloader/local_storage", description = "Could be used to store data" } )
        , ( "Url Downloader", { site = "https://github.com/fluencelabs/fce/tree/master/examples/url-downloader/facade", description = "cURL adapter, allows to download anything by URL" } )
        ]
