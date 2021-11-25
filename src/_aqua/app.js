/**
 *
 * This file is auto-generated. Do not edit manually: changes may be erased.
 * Generated by Aqua compiler: https://github.com/fluencelabs/aqua/.
 * If you find any bugs, please write an issue on GitHub: https://github.com/fluencelabs/aqua/issues
 * Aqua version: 0.5.0-245
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
                      (par
                       (fold services srv
                        (par
                         (seq
                          (call %init_peer_id% ("srv" "get_interface") [srv.$.id!] iface)
                          (xor
                           (call %init_peer_id% ("callbackSrv" "collectServiceInterface") [peer srv.$.id! iface])
                           (call %init_peer_id% ("errorHandlingSrv" "error") [%last_error% 1])
                          )
                         )
                         (next srv)
                        )
                       )
                       (null)
                      )
                     )
                     (call %init_peer_id% ("errorHandlingSrv" "error") [%last_error% 2])
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
                        (seq
                         (seq
                          (seq
                           (call %init_peer_id% ("getDataSrv" "-relay-") [] -relay-)
                           (call %init_peer_id% ("getDataSrv" "peer") [] peer)
                          )
                          (call %init_peer_id% ("peer" "identify") [] ident)
                         )
                         (call %init_peer_id% ("dist" "list_blueprints") [] blueprints)
                        )
                        (call %init_peer_id% ("dist" "list_modules") [] modules)
                       )
                       (call %init_peer_id% ("srv" "list") [] services)
                      )
                      (xor
                       (call %init_peer_id% ("callbackSrv" "collectPeerInfo") [peer ident services blueprints modules])
                       (call %init_peer_id% ("errorHandlingSrv" "error") [%last_error% 1])
                      )
                     )
                     (call %init_peer_id% ("errorHandlingSrv" "error") [%last_error% 2])
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
                       (call %init_peer_id% ("getDataSrv" "-relay-") [] -relay-)
                       (call %init_peer_id% ("getDataSrv" "clientId") [] clientId)
                      )
                      (xor
                       (seq
                        (call -relay- ("kad" "neighborhood") [clientId [] []] neighbors)
                        (par
                         (fold neighbors n
                          (par
                           (xor
                            (seq
                             (call n ("kad" "neighborhood") [n [] []] neighbors2)
                             (par
                              (fold neighbors2 n2
                               (par
                                (seq
                                 (call n ("peer" "connect") [n2 []] connected)
                                 (xor
                                  (match connected true
                                   (xor
                                    (xor
                                     (seq
                                      (seq
                                       (call n2 ("peer" "identify") [])
                                       (call -relay- ("op" "noop") [])
                                      )
                                      (xor
                                       (call %init_peer_id% ("callbackSrv" "logFail") ["success" n2])
                                       (call %init_peer_id% ("errorHandlingSrv" "error") [%last_error% 1])
                                      )
                                     )
                                     (call %init_peer_id% ("errorHandlingSrv" "error") [%last_error% 2])
                                    )
                                    (call %init_peer_id% ("errorHandlingSrv" "error") [%last_error% 3])
                                   )
                                  )
                                  (xor
                                   (call %init_peer_id% ("callbackSrv" "logFail") ["fail" n2])
                                   (call %init_peer_id% ("errorHandlingSrv" "error") [%last_error% 4])
                                  )
                                 )
                                )
                                (next n2)
                               )
                              )
                              (null)
                             )
                            )
                            (call %init_peer_id% ("errorHandlingSrv" "error") [%last_error% 5])
                           )
                           (next n)
                          )
                         )
                         (null)
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
        },
        {
            "name" : "logNeighs",
            "argType" : {
                "tag" : "callback",
                "callback" : {
                    "argDefs" : [
                        {
                            "name" : "arg0",
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
            "name" : "logFail",
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
                       (par
                        (xor
                         (seq
                          (call -relay- ("kad" "neighborhood") [%init_peer_id% [] []] neighbors)
                          (par
                           (fold neighbors n
                            (par
                             (xor
                              (seq
                               (call n ("kad" "neighborhood") [n [] []] neighbors2)
                               (par
                                (fold neighbors2 n2
                                 (par
                                  (seq
                                   (call n ("peer" "connect") [n2 []] connected)
                                   (xor
                                    (match connected true
                                     (xor
                                      (xor
                                       (seq
                                        (seq
                                         (call n2 ("peer" "identify") [])
                                         (call -relay- ("op" "noop") [])
                                        )
                                        (xor
                                         (call %init_peer_id% ("callbackSrv" "logFail") ["success" n2])
                                         (call %init_peer_id% ("errorHandlingSrv" "error") [%last_error% 1])
                                        )
                                       )
                                       (call %init_peer_id% ("errorHandlingSrv" "error") [%last_error% 2])
                                      )
                                      (call %init_peer_id% ("errorHandlingSrv" "error") [%last_error% 3])
                                     )
                                    )
                                    (xor
                                     (call %init_peer_id% ("callbackSrv" "logFail") ["fail" n2])
                                     (call %init_peer_id% ("errorHandlingSrv" "error") [%last_error% 4])
                                    )
                                   )
                                  )
                                  (next n2)
                                 )
                                )
                                (null)
                               )
                              )
                              (call %init_peer_id% ("errorHandlingSrv" "error") [%last_error% 5])
                             )
                             (next n)
                            )
                           )
                           (null)
                          )
                         )
                         (call %init_peer_id% ("errorHandlingSrv" "error") [%last_error% 6])
                        )
                        (null)
                       )
                       (call %init_peer_id% ("errorHandlingSrv" "error") [%last_error% 7])
                      )
                     )
                     (call %init_peer_id% ("errorHandlingSrv" "error") [%last_error% 8])
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
        },
        {
            "name" : "logNeighs",
            "argType" : {
                "tag" : "callback",
                "callback" : {
                    "argDefs" : [
                        {
                            "name" : "arg0",
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
            "name" : "logFail",
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
