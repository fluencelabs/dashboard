// let avm = require('@fluenelabs/avm');
import { AirInterpreter } from '@fluencelabs/avm';
import * as wrapper from '@fluencelabs/avm/dist/wrapper.js';

// > let lib = require(".");
// undefined
let ir = await AirInterpreter.create();
console.dir(AirInterpreter);
console.dir(ir.wasmWrapper);
console.dir(wrapper);
wrapper.ast(ir.wasmWrapper.exports, '');
// undefined
// > ir
// AirInterpreter {
//   wasmWrapper: Instance [WebAssembly.Instance] {},
//   logLevel: undefined
// }
// > lib.AirInterpreter.parseAir
// undefined

// 'error: \n  ┌─ script.air:1:1\n  │\n1 │ \n  │ ^ expected "("\n\n'
// > require('fs').readFile("/private/tmp/aqua_stream_test/test.getCastNetwork.air")
// Uncaught:
// TypeError [ERR_INVALID_CALLBACK]: Callback must be a function. Received undefined
//     at maybeCallback (node:fs:172:3)
//     at Object.readFile (node:fs:329:14)
//     at REPL71:1:15
//     at Script.runInThisContext (node:vm:131:12)
//     at REPLServer.defaultEval (node:repl:522:29)
//     at bound (node:domain:416:15)
//     at REPLServer.runBound [as eval] (node:domain:427:12)
//     at REPLServer.onLine (node:repl:844:10)
//     at REPLServer.emit (node:events:381:22)
//     at REPLServer.emit (node:domain:470:12) {
//   code: 'ERR_INVALID_CALLBACK'
// }
// > await require('fs').readFile("/private/tmp/aqua_stream_test/test.getCastNetwork.air")
// Uncaught:
// TypeError [ERR_INVALID_CALLBACK]: Callback must be a function. Received undefined
//     at maybeCallback (node:fs:172:3)
//     at Object.readFile (node:fs:329:14)
//     at REPL72:1:44
//     at REPL72:2:4
//     at Script.runInThisContext (node:vm:131:12)
//     at REPLServer.defaultEval (node:repl:522:29)
//     at bound (node:domain:416:15)
//     at REPLServer.runBound [as eval] (node:domain:427:12)
//     at REPLServer.onLine (node:repl:844:10)
//     at REPLServer.emit (node:events:381:22) {
//   code: 'ERR_INVALID_CALLBACK'
// }
// > await require('fs/promises').readFile("/private/tmp/aqua_stream_test/test.getCastNetwork.air")
