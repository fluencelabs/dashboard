import { object, number, string, array, SchemaOf, boolean } from "yup";

export const service: SchemaOf<Service> = object({
    id: string().required(),
    owner_id: string().required(),
    blueprint_id: string().required(),
});

export const blueprint: SchemaOf<Blueprint> = object({
    dependencies: array(string()).required(),
    id: string().required(),
    name: string().required(),
    facade: string().nullable().notRequired(),
});

export const mountedBinaries: SchemaOf<MountedBinaries> = object({
    curl: string().required(),
});

export const identify: SchemaOf<Identify> = object({
    external_addresses: array(string()).required(),
});

export const wasi: SchemaOf<Wasi> = object({
    envs: object().notRequired(),
    mapped_dirs: object().notRequired(),
    preopened_files: array(object()).notRequired(),
})

export const config: SchemaOf<Config> = object({
    logger_enabled: boolean().required(),
    logging_mask: object().required(),
    mem_pages_count: number().required(),
    mounted_binaries: mountedBinaries.required(),
    wasi: wasi.required(),
})

export const module: SchemaOf<Module> = object({
    config: config.required(),
    hash: string().required(),
    name: string().required(),
})

export const eventType: SchemaOf<EventType> = object({
    peerId: string().required(),
    identify: identify.required(),
    services: array(service).required(),
    blueprints: array(blueprint).required(),
    modules: array(module).required(),
})

export interface Service {
    blueprint_id: string;
    id: string;
    owner_id: string;
}

export interface Blueprint {
    dependencies: string[];
    facade?: any;
    id: string;
    name: string;
}

export interface MountedBinaries {
    curl: string;
}

export interface Wasi {
    envs?: any;
    mapped_dirs?: any;
    preopened_files: any[];
}

export interface Config {
    logger_enabled: boolean;
    logging_mask?: any;
    mem_pages_count: number;
    mounted_binaries: MountedBinaries;
    wasi: Wasi;
}

export interface Module {
    config: Config;
    hash: string;
    name: string;
}

export interface Identify {
    external_addresses: string[]
}

export interface EventType {
    peerId: string,
    identify: Identify,
    services: Service[],
    blueprints: Blueprint[],
    modules: Module[],
}
