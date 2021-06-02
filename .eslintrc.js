module.exports = {
    parser: '@typescript-eslint/parser',
    parserOptions: {
        ecmaVersion: 12,
        sourceType: 'module', // Allows for the use of imports
    },
    env: {
        browser: true,
        es2021: true,
    },
    extends: [
        'airbnb-base',
        'plugin:@typescript-eslint/eslint-recommended',
        'plugin:@typescript-eslint/recommended',
        // Enables eslint-plugin-prettier and eslint-config-prettier. This will display prettier errors as ESLint errors. Make sure this is always the last configuration in the extends array.
        'plugin:prettier/recommended',
    ],
    plugins: ['@typescript-eslint', 'prettier'],
    rules: {
        'func-names': ['error', 'as-needed'],
        'prefer-destructuring': 'off',
        'object-shorthand': ['error', 'consistent-as-needed'],
        'no-restricted-syntax': ['error', 'ForInStatement', 'LabeledStatement', 'WithStatement'],

        'import/prefer-default-export': 'off',
        'import/extensions': [
            'error',
            'ignorePackages',
            {
                js: 'never',
                mjs: 'never',
                jsx: 'never',
                ts: 'never',
                tsx: 'never',
            },
        ],
        'no-unused-vars': 'off',
        '@typescript-eslint/no-unused-vars': ['error', { varsIgnorePattern: '^_', argsIgnorePattern: '^_' }],
        '@typescript-eslint/no-explicit-any': 'off',

        // should be overriden for current project only
        'no-param-reassign': ['error', { props: false }],
        'no-console': 'off',
        '@typescript-eslint/explicit-module-boundary-types': 'off',
    },
    settings: {
        'import/extensions': ['.js', '.ts', '.jsx', '.tsx'],
        'import/resolver': {
            typescript: {},
            node: {
                paths: ['src'],
            },
        },
    },
};
