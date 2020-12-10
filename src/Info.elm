module Info exposing (..)

import Dict exposing (Dict)


type alias ModuleDescription =
    { site : String
    , description : String
    }

type alias BlueprintDescription =
    { description : String
    }


getSite : String -> String
getSite name =
    modulesDescription |> Dict.get name |> Maybe.map .site |> Maybe.withDefault ""


getModuleDescription : String -> String
getModuleDescription name =
    modulesDescription |> Dict.get name |> Maybe.map .description |> Maybe.withDefault ""

getBlueprintDescription : String -> String
getBlueprintDescription name =
    blueprintsDescription |> Dict.get name |> Maybe.map .description |> Maybe.withDefault ""

modulesDescription : Dict String ModuleDescription
modulesDescription =
    Dict.fromList
        [ ( "sqlite3", { site = "https://github.com/fluencelabs/sqlite", description = "Popular embeddable database compiled to WebAssembly, stores data in memory" } )
        , ( "sqlite", { site = "https://github.com/fluencelabs/sqlite", description = "Popular embeddable database compiled to WebAssembly, stores data in memory" } )
        , ( "history", { site = "https://github.com/fluencelabs/aqua-demo/tree/master/services/history", description = "Stores message log, used in History service" } )
        , ( "userlist", { site = "https://github.com/fluencelabs/aqua-demo/tree/master/services/user-list", description = "Address book implementation module, used in User List service" } )
        , ( "redis", { site = "https://github.com/fluencelabs/redis", description = "Popular NoSQL K/V storage compiled to WebAssembly, stores data in memory" } )
        , ( "curl", { site = "https://github.com/fluencelabs/fce/tree/master/examples/url-downloader/curl", description = "Adapter module for cURL CLI utility" } )
        , ( "local_storage", { site = "https://github.com/fluencelabs/fce/tree/master/examples/url-downloader/local_storage", description = "Provides methods for working with file system: put and get" } )
        , ( "curl_adapter", { site = "https://github.com/fluencelabs/fce/tree/master/examples/url-downloader/facade", description = "Adapter module for cURL CLI utility" } )
        , ( "url_downloader", { site = "https://github.com/fluencelabs/fce/tree/master/examples/url-downloader/facade", description = "Adapter module for cURL CLI utility" } )
        , ( "facade_url_downloader", { site = "https://github.com/fluencelabs/fce/tree/master/examples/url-downloader/facade", description = "Adapter module for cURL CLI utility" } )
        ]

blueprintsDescription : Dict String BlueprintDescription
blueprintsDescription =
    Dict.fromList
        [ ( "SQLite 3", { description = "Popular embeddable database compiled to WebAssembly" } )
        , ( "Message History", { description = "Stores message log, used in the Chat application" } )
        , ( "User List", { description = "Basically an address book. Used in the Chat application to store chat users" } )
        , ( "Redis", { description = "Popular NoSQL K/V storage compiled to WebAssembly, stores data in memory" } )
        , ( "URL Downloader", { description = "cURL adapter, allows to download anything by URL" } )
        ]
