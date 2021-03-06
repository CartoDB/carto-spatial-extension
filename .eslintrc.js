module.exports = {
    env: {
        commonjs: true,
        es2020: true,
        node: true,
        jest: true
    },
    extends: [
        'eslint:recommended'
    ],
    parserOptions: {
        ecmaVersion: 11,
        sourceType: 'module'
    },
    ignorePatterns: [
        'dist/*',
        '*fixture*',
        '*custom*'
    ],
    rules: {
        quotes: ['error', 'single'],
        indent: ['error', 4],
        'eol-last': ['error', 'never'],
        'comma-dangle': ['error', 'never'],
        'keyword-spacing': ['error', { before: true }],
        'no-path-concat': ['off'],
        'space-before-function-paren': ['error', 'always'],
        'object-curly-spacing': ['error', 'always']
    }
};