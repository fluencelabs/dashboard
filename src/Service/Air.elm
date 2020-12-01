module Service.Air exposing (..)

import Air exposing (Air)
import AirScripts.CallPeers


air : String -> String -> List String -> Air
air peerId relayId peers =
    AirScripts.CallPeers.air peerId relayId ( "services_discovered", "srv", "get_interfaces" ) peers
