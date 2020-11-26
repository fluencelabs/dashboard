module Blueprints.Air exposing (..)

import Air exposing (Air)
import AirScripts.CallPeers
air : String -> String -> List String -> Air
air peerId relayId peers =
    AirScripts.CallPeers.air peerId relayId ("blueprints_discovered", "dist", "get_blueprints") peers