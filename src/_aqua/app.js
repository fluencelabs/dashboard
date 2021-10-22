/**
 *
 * This file is auto-generated. Do not edit manually: changes may be erased.
 * Generated by Aqua compiler: https://github.com/fluencelabs/aqua/.
 * If you find any bugs, please write an issue on GitHub: https://github.com/fluencelabs/aqua/issues
 * Aqua version: 0.4.0-235
 *
 */
import { Fluence, FluencePeer } from '@fluencelabs/fluence';
import {
    CallParams,
    callFunction,
    registerService,
} from '@fluencelabs/fluence/dist/internal/compilerSupport/v2';


// Services

// Functions

export function collectServiceInterfaces(...args) {

    let script = `
                        (xor
                     (seq
                      (seq
                       (seq
                        (call %init_peer_id% ("getDataSrv" "-relay-") [] -relay-)
                        (call %init_peer_id% ("getDataSrv" "peer") [] peer)
                       )
                       (call %init_peer_id% ("getDataSrv" "services") [] services)
                      )
                      (fold services srv
                       (par
                        (seq
                         (call -relay- ("op" "noop") [])
                         (xor
                          (seq
                           (seq
                            (call peer ("srv" "get_interface") [srv.$.id!] iface)
                            (call -relay- ("op" "noop") [])
                           )
                           (xor
                            (call %init_peer_id% ("callbackSrv" "collectServiceInterface") [peer srv.$.id! iface])
                            (call %init_peer_id% ("errorHandlingSrv" "error") [%last_error% 1])
                           )
                          )
                          (call %init_peer_id% ("errorHandlingSrv" "error") [%last_error% 2])
                         )
                        )
                        (next srv)
                       )
                      )
                     )
                     (call %init_peer_id% ("errorHandlingSrv" "error") [%last_error% 3])
                    )
    `
    return callFunction(
        args,
        {
    "functionName" : "collectServiceInterfaces",
    "returnType" : {
        "tag" : "void"
    },
    "argDefs" : [
        {
            "name" : "peer",
            "argType" : {
                "tag" : "primitive"
            }
        },
        {
            "name" : "services",
            "argType" : {
                "tag" : "primitive"
            }
        },
        {
            "name" : "collectServiceInterface",
            "argType" : {
                "tag" : "callback",
                "callback" : {
                    "argDefs" : [
                        {
                            "name" : "arg0",
                            "argType" : {
                                "tag" : "primitive"
                            }
                        },
                        {
                            "name" : "arg1",
                            "argType" : {
                                "tag" : "primitive"
                            }
                        },
                        {
                            "name" : "arg2",
                            "argType" : {
                                "tag" : "primitive"
                            }
                        }
                    ],
                    "returnType" : {
                        "tag" : "void"
                    }
                }
            }
        }
    ],
    "names" : {
        "relay" : "-relay-",
        "getDataSrv" : "getDataSrv",
        "callbackSrv" : "callbackSrv",
        "responseSrv" : "callbackSrv",
        "responseFnName" : "response",
        "errorHandlingSrv" : "errorHandlingSrv",
        "errorFnName" : "error"
    }
},
        script
    )
}


export function askAllAndSend(...args) {

    let script = `
                        (xor
                     (seq
                      (seq
                       (seq
                        (call %init_peer_id% ("getDataSrv" "-relay-") [] -relay-)
                        (call %init_peer_id% ("getDataSrv" "peer") [] peer)
                       )
                       (call -relay- ("op" "noop") [])
                      )
                      (xor
                       (seq
                        (seq
                         (seq
                          (seq
                           (seq
                            (seq
                             (seq
                              (call peer ("peer" "identify") [] ident)
                              (call peer ("dist" "list_blueprints") [] blueprints)
                             )
                             (call peer ("dist" "list_modules") [] modules)
                            )
                            (call peer ("srv" "list") [] services)
                           )
                           (call -relay- ("op" "noop") [])
                          )
                          (xor
                           (call %init_peer_id% ("callbackSrv" "collectPeerInfo") [peer ident services blueprints modules])
                           (call %init_peer_id% ("errorHandlingSrv" "error") [%last_error% 1])
                          )
                         )
                         (call -relay- ("op" "noop") [])
                        )
                        (fold services srv
                         (par
                          (seq
                           (call -relay- ("op" "noop") [])
                           (xor
                            (seq
                             (seq
                              (call peer ("srv" "get_interface") [srv.$.id!] iface)
                              (call -relay- ("op" "noop") [])
                             )
                             (xor
                              (call %init_peer_id% ("callbackSrv" "collectServiceInterface") [peer srv.$.id! iface])
                              (call %init_peer_id% ("errorHandlingSrv" "error") [%last_error% 2])
                             )
                            )
                            (call %init_peer_id% ("errorHandlingSrv" "error") [%last_error% 3])
                           )
                          )
                          (seq
                           (call -relay- ("op" "noop") [])
                           (next srv)
                          )
                         )
                        )
                       )
                       (call %init_peer_id% ("errorHandlingSrv" "error") [%last_error% 4])
                      )
                     )
                     (call %init_peer_id% ("errorHandlingSrv" "error") [%last_error% 5])
                    )
    `
    return callFunction(
        args,
        {
    "functionName" : "askAllAndSend",
    "returnType" : {
        "tag" : "void"
    },
    "argDefs" : [
        {
            "name" : "peer",
            "argType" : {
                "tag" : "primitive"
            }
        },
        {
            "name" : "collectPeerInfo",
            "argType" : {
                "tag" : "callback",
                "callback" : {
                    "argDefs" : [
                        {
                            "name" : "arg0",
                            "argType" : {
                                "tag" : "primitive"
                            }
                        },
                        {
                            "name" : "arg1",
                            "argType" : {
                                "tag" : "primitive"
                            }
                        },
                        {
                            "name" : "arg2",
                            "argType" : {
                                "tag" : "primitive"
                            }
                        },
                        {
                            "name" : "arg3",
                            "argType" : {
                                "tag" : "primitive"
                            }
                        },
                        {
                            "name" : "arg4",
                            "argType" : {
                                "tag" : "primitive"
                            }
                        }
                    ],
                    "returnType" : {
                        "tag" : "void"
                    }
                }
            }
        },
        {
            "name" : "collectServiceInterface",
            "argType" : {
                "tag" : "callback",
                "callback" : {
                    "argDefs" : [
                        {
                            "name" : "arg0",
                            "argType" : {
                                "tag" : "primitive"
                            }
                        },
                        {
                            "name" : "arg1",
                            "argType" : {
                                "tag" : "primitive"
                            }
                        },
                        {
                            "name" : "arg2",
                            "argType" : {
                                "tag" : "primitive"
                            }
                        }
                    ],
                    "returnType" : {
                        "tag" : "void"
                    }
                }
            }
        }
    ],
    "names" : {
        "relay" : "-relay-",
        "getDataSrv" : "getDataSrv",
        "callbackSrv" : "callbackSrv",
        "responseSrv" : "callbackSrv",
        "responseFnName" : "response",
        "errorHandlingSrv" : "errorHandlingSrv",
        "errorFnName" : "error"
    }
},
        script
    )
}


export function findAndAskNeighboursSchema(...args) {

    let script = `
                        (xor
                     (seq
                      (seq
                       (seq
                        (seq
                         (call %init_peer_id% ("getDataSrv" "-relay-") [] -relay-)
                         (call %init_peer_id% ("getDataSrv" "relayPeerId") [] relayPeerId)
                        )
                        (call %init_peer_id% ("getDataSrv" "clientId") [] clientId)
                       )
                       (call -relay- ("op" "noop") [])
                      )
                      (xor
                       (seq
                        (call relayPeerId ("kad" "neighborhood") [clientId [] []] neighbors)
                        (fold neighbors n
                         (par
                          (xor
                           (seq
                            (call n ("kad" "neighborhood") [clientId [] []] neighbors2)
                            (fold neighbors2 n2
                             (par
                              (seq
                               (call -relay- ("op" "noop") [])
                               (xor
                                (seq
                                 (seq
                                  (seq
                                   (seq
                                    (seq
                                     (seq
                                      (seq
                                       (call n2 ("peer" "identify") [] ident)
                                       (call n2 ("dist" "list_blueprints") [] blueprints)
                                      )
                                      (call n2 ("dist" "list_modules") [] modules)
                                     )
                                     (call n2 ("srv" "list") [] services)
                                    )
                                    (call -relay- ("op" "noop") [])
                                   )
                                   (xor
                                    (call %init_peer_id% ("callbackSrv" "collectPeerInfo") [n2 ident services blueprints modules])
                                    (call %init_peer_id% ("errorHandlingSrv" "error") [%last_error% 1])
                                   )
                                  )
                                  (call -relay- ("op" "noop") [])
                                 )
                                 (fold services srv
                                  (par
                                   (seq
                                    (call -relay- ("op" "noop") [])
                                    (xor
                                     (seq
                                      (seq
                                       (call n2 ("srv" "get_interface") [srv.$.id!] iface)
                                       (call -relay- ("op" "noop") [])
                                      )
                                      (xor
                                       (call %init_peer_id% ("callbackSrv" "collectServiceInterface") [n2 srv.$.id! iface])
                                       (call %init_peer_id% ("errorHandlingSrv" "error") [%last_error% 2])
                                      )
                                     )
                                     (call %init_peer_id% ("errorHandlingSrv" "error") [%last_error% 3])
                                    )
                                   )
                                   (seq
                                    (call -relay- ("op" "noop") [])
                                    (next srv)
                                   )
                                  )
                                 )
                                )
                                (seq
                                 (call -relay- ("op" "noop") [])
                                 (call %init_peer_id% ("errorHandlingSrv" "error") [%last_error% 4])
                                )
                               )
                              )
                              (next n2)
                             )
                            )
                           )
                           (seq
                            (call -relay- ("op" "noop") [])
                            (call %init_peer_id% ("errorHandlingSrv" "error") [%last_error% 5])
                           )
                          )
                          (next n)
                         )
                        )
                       )
                       (call %init_peer_id% ("errorHandlingSrv" "error") [%last_error% 6])
                      )
                     )
                     (call %init_peer_id% ("errorHandlingSrv" "error") [%last_error% 7])
                    )
    `
    return callFunction(
        args,
        {
    "functionName" : "findAndAskNeighboursSchema",
    "returnType" : {
        "tag" : "void"
    },
    "argDefs" : [
        {
            "name" : "relayPeerId",
            "argType" : {
                "tag" : "primitive"
            }
        },
        {
            "name" : "clientId",
            "argType" : {
                "tag" : "primitive"
            }
        },
        {
            "name" : "collectPeerInfo",
            "argType" : {
                "tag" : "callback",
                "callback" : {
                    "argDefs" : [
                        {
                            "name" : "arg0",
                            "argType" : {
                                "tag" : "primitive"
                            }
                        },
                        {
                            "name" : "arg1",
                            "argType" : {
                                "tag" : "primitive"
                            }
                        },
                        {
                            "name" : "arg2",
                            "argType" : {
                                "tag" : "primitive"
                            }
                        },
                        {
                            "name" : "arg3",
                            "argType" : {
                                "tag" : "primitive"
                            }
                        },
                        {
                            "name" : "arg4",
                            "argType" : {
                                "tag" : "primitive"
                            }
                        }
                    ],
                    "returnType" : {
                        "tag" : "void"
                    }
                }
            }
        },
        {
            "name" : "collectServiceInterface",
            "argType" : {
                "tag" : "callback",
                "callback" : {
                    "argDefs" : [
                        {
                            "name" : "arg0",
                            "argType" : {
                                "tag" : "primitive"
                            }
                        },
                        {
                            "name" : "arg1",
                            "argType" : {
                                "tag" : "primitive"
                            }
                        },
                        {
                            "name" : "arg2",
                            "argType" : {
                                "tag" : "primitive"
                            }
                        }
                    ],
                    "returnType" : {
                        "tag" : "void"
                    }
                }
            }
        }
    ],
    "names" : {
        "relay" : "-relay-",
        "getDataSrv" : "getDataSrv",
        "callbackSrv" : "callbackSrv",
        "responseSrv" : "callbackSrv",
        "responseFnName" : "response",
        "errorHandlingSrv" : "errorHandlingSrv",
        "errorFnName" : "error"
    }
},
        script
    )
}


export function getAll(...args) {

    let script = `
                        (xor
                     (seq
                      (seq
                       (call %init_peer_id% ("getDataSrv" "-relay-") [] -relay-)
                       (call %init_peer_id% ("getDataSrv" "knownPeers") [] knownPeers)
                      )
                      (xor
                       (fold knownPeers peer
                        (par
                         (seq
                          (call -relay- ("op" "noop") [])
                          (xor
                           (seq
                            (seq
                             (seq
                              (seq
                               (seq
                                (seq
                                 (seq
                                  (call peer ("peer" "identify") [] ident)
                                  (call peer ("dist" "list_blueprints") [] blueprints)
                                 )
                                 (call peer ("dist" "list_modules") [] modules)
                                )
                                (call peer ("srv" "list") [] services)
                               )
                               (call -relay- ("op" "noop") [])
                              )
                              (xor
                               (call %init_peer_id% ("callbackSrv" "collectPeerInfo") [peer ident services blueprints modules])
                               (call %init_peer_id% ("errorHandlingSrv" "error") [%last_error% 1])
                              )
                             )
                             (call -relay- ("op" "noop") [])
                            )
                            (fold services srv
                             (par
                              (seq
                               (call -relay- ("op" "noop") [])
                               (xor
                                (seq
                                 (seq
                                  (call peer ("srv" "get_interface") [srv.$.id!] iface)
                                  (call -relay- ("op" "noop") [])
                                 )
                                 (xor
                                  (call %init_peer_id% ("callbackSrv" "collectServiceInterface") [peer srv.$.id! iface])
                                  (call %init_peer_id% ("errorHandlingSrv" "error") [%last_error% 2])
                                 )
                                )
                                (call %init_peer_id% ("errorHandlingSrv" "error") [%last_error% 3])
                               )
                              )
                              (seq
                               (call -relay- ("op" "noop") [])
                               (next srv)
                              )
                             )
                            )
                           )
                           (call %init_peer_id% ("errorHandlingSrv" "error") [%last_error% 4])
                          )
                         )
                         (next peer)
                        )
                       )
                       (call %init_peer_id% ("errorHandlingSrv" "error") [%last_error% 5])
                      )
                     )
                     (call %init_peer_id% ("errorHandlingSrv" "error") [%last_error% 6])
                    )
    `
    return callFunction(
        args,
        {
    "functionName" : "getAll",
    "returnType" : {
        "tag" : "void"
    },
    "argDefs" : [
        {
            "name" : "knownPeers",
            "argType" : {
                "tag" : "primitive"
            }
        },
        {
            "name" : "collectPeerInfo",
            "argType" : {
                "tag" : "callback",
                "callback" : {
                    "argDefs" : [
                        {
                            "name" : "arg0",
                            "argType" : {
                                "tag" : "primitive"
                            }
                        },
                        {
                            "name" : "arg1",
                            "argType" : {
                                "tag" : "primitive"
                            }
                        },
                        {
                            "name" : "arg2",
                            "argType" : {
                                "tag" : "primitive"
                            }
                        },
                        {
                            "name" : "arg3",
                            "argType" : {
                                "tag" : "primitive"
                            }
                        },
                        {
                            "name" : "arg4",
                            "argType" : {
                                "tag" : "primitive"
                            }
                        }
                    ],
                    "returnType" : {
                        "tag" : "void"
                    }
                }
            }
        },
        {
            "name" : "collectServiceInterface",
            "argType" : {
                "tag" : "callback",
                "callback" : {
                    "argDefs" : [
                        {
                            "name" : "arg0",
                            "argType" : {
                                "tag" : "primitive"
                            }
                        },
                        {
                            "name" : "arg1",
                            "argType" : {
                                "tag" : "primitive"
                            }
                        },
                        {
                            "name" : "arg2",
                            "argType" : {
                                "tag" : "primitive"
                            }
                        }
                    ],
                    "returnType" : {
                        "tag" : "void"
                    }
                }
            }
        }
    ],
    "names" : {
        "relay" : "-relay-",
        "getDataSrv" : "getDataSrv",
        "callbackSrv" : "callbackSrv",
        "responseSrv" : "callbackSrv",
        "responseFnName" : "response",
        "errorHandlingSrv" : "errorHandlingSrv",
        "errorFnName" : "error"
    }
},
        script
    )
}
