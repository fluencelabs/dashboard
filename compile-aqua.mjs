// @ts-check

import { join } from 'path';
import { compileFromPath } from './node_modules/@fluencelabs/aqua-api/index.js';
import { mkdir, writeFile } from 'fs/promises';

const { generatedSources } = await compileFromPath({
    targetType: 'js',
    filePath: join('aqua', 'app.aqua'),
    imports: ['node_modules'],
});

const targetDir = join('src', '_aqua');

await mkdir(targetDir, { recursive: true });

// @ts-ignore
await writeFile(join(targetDir, 'app.js'), generatedSources[0].jsSource, { encoding: 'utf8' });
