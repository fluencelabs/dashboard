/**
 *
 * This file is auto-generated. Do not edit manually: changes may be erased.
 * Generated by Aqua compiler: https://github.com/fluencelabs/aqua/.
 * If you find any bugs, please write an issue on GitHub: https://github.com/fluencelabs/aqua/issues
 * Aqua version: 0.4.0-238
 *
 */
import { Fluence, FluencePeer } from '@fluencelabs/fluence';
import {
    CallParams,
    callFunction,
    registerService,
} from '@fluencelabs/fluence/dist/internal/compilerSupport/v2';


// Services
export interface MyOpDef {
    array: (i: { function_signatures: { arguments: string[][]; name: string; output_types: string[]; }[]; record_types: { fields: string[][]; id: number; name: string; }[]; }, s: string, callParams: CallParams<'i' | 's'>) => number | Promise<number>;
}
export function registerMyOp(service: MyOpDef): void;
export function registerMyOp(serviceId: string, service: MyOpDef): void;
export function registerMyOp(peer: FluencePeer, service: MyOpDef): void;
export function registerMyOp(peer: FluencePeer, serviceId: string, service: MyOpDef): void;
       

// Functions
 

export function collectServiceInterfaces(peer_: string, services: { blueprint_id: string; id: string; owner_id: string; }[], collectServiceInterface: (arg0: string, arg1: number[], callParams: CallParams<'arg0' | 'arg1'>) => void | Promise<void>, log: (arg0: string, callParams: CallParams<'arg0'>) => void | Promise<void>, config?: {ttl?: number}): Promise<void>;
export function collectServiceInterfaces(peer: FluencePeer, peer_: string, services: { blueprint_id: string; id: string; owner_id: string; }[], collectServiceInterface: (arg0: string, arg1: number[], callParams: CallParams<'arg0' | 'arg1'>) => void | Promise<void>, log: (arg0: string, callParams: CallParams<'arg0'>) => void | Promise<void>, config?: {ttl?: number}): Promise<void>;

 

export function askAllAndSend(peer_: string, collectPeerInfo: (arg0: string, arg1: { external_addresses: string[]; }, arg2: { blueprint_id: string; id: string; owner_id: string; }[], arg3: { dependencies: string[]; id: string; name: string; }[], arg4: { config: { name: string; }; hash: string; name: string; }[], callParams: CallParams<'arg0' | 'arg1' | 'arg2' | 'arg3' | 'arg4'>) => void | Promise<void>, collectServiceInterface: (arg0: string, arg1: number[], callParams: CallParams<'arg0' | 'arg1'>) => void | Promise<void>, log: (arg0: string, callParams: CallParams<'arg0'>) => void | Promise<void>, config?: {ttl?: number}): Promise<void>;
export function askAllAndSend(peer: FluencePeer, peer_: string, collectPeerInfo: (arg0: string, arg1: { external_addresses: string[]; }, arg2: { blueprint_id: string; id: string; owner_id: string; }[], arg3: { dependencies: string[]; id: string; name: string; }[], arg4: { config: { name: string; }; hash: string; name: string; }[], callParams: CallParams<'arg0' | 'arg1' | 'arg2' | 'arg3' | 'arg4'>) => void | Promise<void>, collectServiceInterface: (arg0: string, arg1: number[], callParams: CallParams<'arg0' | 'arg1'>) => void | Promise<void>, log: (arg0: string, callParams: CallParams<'arg0'>) => void | Promise<void>, config?: {ttl?: number}): Promise<void>;

 

export function findAndAskNeighboursSchema(relayPeerId: string, clientId: string, collectPeerInfo: (arg0: string, arg1: { external_addresses: string[]; }, arg2: { blueprint_id: string; id: string; owner_id: string; }[], arg3: { dependencies: string[]; id: string; name: string; }[], arg4: { config: { name: string; }; hash: string; name: string; }[], callParams: CallParams<'arg0' | 'arg1' | 'arg2' | 'arg3' | 'arg4'>) => void | Promise<void>, collectServiceInterface: (arg0: string, arg1: number[], callParams: CallParams<'arg0' | 'arg1'>) => void | Promise<void>, log: (arg0: string, callParams: CallParams<'arg0'>) => void | Promise<void>, config?: {ttl?: number}): Promise<void>;
export function findAndAskNeighboursSchema(peer: FluencePeer, relayPeerId: string, clientId: string, collectPeerInfo: (arg0: string, arg1: { external_addresses: string[]; }, arg2: { blueprint_id: string; id: string; owner_id: string; }[], arg3: { dependencies: string[]; id: string; name: string; }[], arg4: { config: { name: string; }; hash: string; name: string; }[], callParams: CallParams<'arg0' | 'arg1' | 'arg2' | 'arg3' | 'arg4'>) => void | Promise<void>, collectServiceInterface: (arg0: string, arg1: number[], callParams: CallParams<'arg0' | 'arg1'>) => void | Promise<void>, log: (arg0: string, callParams: CallParams<'arg0'>) => void | Promise<void>, config?: {ttl?: number}): Promise<void>;

 

export function getAll(knownPeers: string[], collectPeerInfo: (arg0: string, arg1: { external_addresses: string[]; }, arg2: { blueprint_id: string; id: string; owner_id: string; }[], arg3: { dependencies: string[]; id: string; name: string; }[], arg4: { config: { name: string; }; hash: string; name: string; }[], callParams: CallParams<'arg0' | 'arg1' | 'arg2' | 'arg3' | 'arg4'>) => void | Promise<void>, collectServiceInterface: (arg0: string, arg1: number[], callParams: CallParams<'arg0' | 'arg1'>) => void | Promise<void>, log: (arg0: string, callParams: CallParams<'arg0'>) => void | Promise<void>, config?: {ttl?: number}): Promise<void>;
export function getAll(peer: FluencePeer, knownPeers: string[], collectPeerInfo: (arg0: string, arg1: { external_addresses: string[]; }, arg2: { blueprint_id: string; id: string; owner_id: string; }[], arg3: { dependencies: string[]; id: string; name: string; }[], arg4: { config: { name: string; }; hash: string; name: string; }[], callParams: CallParams<'arg0' | 'arg1' | 'arg2' | 'arg3' | 'arg4'>) => void | Promise<void>, collectServiceInterface: (arg0: string, arg1: number[], callParams: CallParams<'arg0' | 'arg1'>) => void | Promise<void>, log: (arg0: string, callParams: CallParams<'arg0'>) => void | Promise<void>, config?: {ttl?: number}): Promise<void>;
