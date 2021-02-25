module Modules.Air exposing (..)

import Air exposing (Air)
import AirScripts.CallPeers


air : String -> String -> List String -> Air
air peerId relayId peers =
    AirScripts.CallPeers.air peerId relayId ( "modules_discovered", "dist", "list_modules" ) peers
