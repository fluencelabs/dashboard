// @ts-check

import { join } from 'path';
import { AquaConfig, Aqua, Path } from './node_modules/@fluencelabs/aqua-api/aqua-api.js';
import { mkdir, writeFile } from 'fs/promises';

function getConfig({
    constants = [],
    logLevel = 'info',
    noRelay = false,
    noXor = false,
    targetType = 'air',
    tracing = false,
}) {
    return new AquaConfig(
        logLevel,
        constants,
        noXor,
        noRelay,
        {
            ts: 'typescript',
            js: 'javascript',
            air: 'air',
        }[targetType],
        tracing,
    );
}

function compileFromPath({ filePath, ...commonArgs }) {
    const config = getConfig(commonArgs);
    const { imports = [] } = commonArgs;
    return Aqua.compile(new Path(filePath), imports, config);
}

const { generatedSources } = await compileFromPath({
    targetType: 'js',
    filePath: join('aqua', 'app.aqua'),
    imports: ['node_modules'],
});

const targetDir = join('src', '_aqua');

await mkdir(targetDir, { recursive: true });

// @ts-ignore
await writeFile(join(targetDir, 'app.js'), generatedSources[0].jsSource, { encoding: 'utf8' });
