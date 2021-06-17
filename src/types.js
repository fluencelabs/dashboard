import { object, number, string, array, boolean } from 'yup';

export const service = object({
    id: string().required(),
    owner_id: string().required(),
    blueprint_id: string().required(),
});

export const blueprint = object({
    dependencies: array(string()).required(),
    id: string().required(),
    name: string().required(),
    facade: string().nullable().notRequired(),
});

export const identify = object({
    external_addresses: array(string()).required(),
});

export const wasi = object({
    envs: object().notRequired().nullable(),
    mapped_dirs: object().notRequired().nullable(),
    preopened_files: array(string()).notRequired().nullable(),
});

export const config = object({
    logger_enabled: boolean().notRequired().nullable(),
    logging_mask: object().notRequired().nullable(),
    mem_pages_count: number().notRequired().nullable(),
    mounted_binaries: object().notRequired().nullable(),
    wasi: wasi.notRequired().nullable(),
});

export const module = object({
    config: config.required(),
    hash: string().required(),
    name: string().required(),
});

export const peerInfo = object({
    peerId: string().required(),
    identify: identify.required(),
    services: array(service).required(),
    blueprints: array(blueprint).required(),
    modules: array(module).required(),
});
