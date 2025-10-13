/* ESLint configuration for SIMAPRO Backend */
module.exports = {
  root: true,
  env: {
    node: true,
    jest: true,
    es2022: true,
  },
  parserOptions: {
    ecmaVersion: 'latest',
    sourceType: 'script',
  },
  extends: [
    'eslint:recommended',
    'plugin:promise/recommended',
    'plugin:import/recommended',
    'plugin:node/recommended',
    'prettier'
  ],
  plugins: ['promise', 'import'],
  rules: {
    'no-unused-vars': ['warn', { argsIgnorePattern: '^_' }],
    'no-console': 'off',
    'import/no-unresolved': 'off',
    'node/no-unsupported-features/es-syntax': 'off',
    'node/no-missing-require': 'off',
    'promise/always-return': 'off',
    'promise/catch-or-return': 'off'
  },
  overrides: [
    {
      files: ['**/tests/**/*.js'],
      env: { jest: true },
    }
  ]
};
