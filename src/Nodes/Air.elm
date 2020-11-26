module Nodes.Air exposing (..)

import Air exposing (Air)
import AirScripts.CallPeers


air : String -> String -> List String -> Air
air peerId relayId peers =
    AirScripts.CallPeers.air peerId relayId ("peer_identity", "op", "identify") peers