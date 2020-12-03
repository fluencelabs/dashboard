module Info exposing (..)



import Dict exposing (Dict)

type alias ModuleDescription =
    { site: String
    , description: String
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
    [ ("sqlite3", { site = "https://github.com/fluencelabs/sqlite", description = "A database that ported on Wasm"})
    , ("history", { site = "https://github.com/fluencelabs/aqua-demo/tree/master/services/history", description = "Middleware that stores history (i.e. chat messages) in sqlite"})
    , ("user-list", { site = "https://github.com/fluencelabs/aqua-demo/tree/master/services/user-list", description = "Middleware that stores users with their auth (i.e. chat members) in sqlite"})
    , ("redis", { site = "https://github.com/fluencelabs/redis", description = "A database that ported on Wasm"})
    , ("curl", { site = "https://github.com/fluencelabs/fce/tree/master/examples/url-downloader/curl", description = "Module that call 'curl' command"})
    , ("facade", { site = "https://github.com/fluencelabs/fce/tree/master/examples/url-downloader/facade", description = "An API facade for Url-Downloader app"})
    , ("local_storage", { site = "https://github.com/fluencelabs/fce/tree/master/examples/url-downloader/local_storage", description = "Could be used to store data"})
    ]