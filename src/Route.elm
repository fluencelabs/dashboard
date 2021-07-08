module Route exposing (..)

import Url.Parser exposing ((</>), Parser, map, oneOf, s, string, top)


type Route
    = Home
    | Hub
    | Nodes
    | Blueprint String
    | Module String
    | Peer String
    | Unknown String


routeParser : Parser (Route -> a) a
routeParser =
    oneOf
        [ map Home top
        , map Hub (s "hub")
        , map Nodes (s "nodes")
        , map Blueprint (s "blueprint" </> string)
        , map Module (s "module" </> string)
        , map Peer (s "peer" </> string)
        , map Unknown string
        ]


parse url =
    Maybe.withDefault Home <| Url.Parser.parse routeParser url
