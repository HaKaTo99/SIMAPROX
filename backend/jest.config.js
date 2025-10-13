/** @type {import('jest').Config} */
module.exports = {
  testEnvironment: 'node',
  roots: ['<rootDir>/tests'],
  testMatch: ['**/?(*.)+(spec|test).[jt]s'],
  verbose: true,
  collectCoverageFrom: ['src/**/*.js', '!src/**/index.js'],
  coverageDirectory: 'coverage',
  // Initial coverage gates (set near current baseline). TODO: Increment after adding domain tests.
  coverageThreshold: {
    global: {
      statements: 55,
      branches: 35,
      functions: 45,
      lines: 55
    }
  },
  setupFiles: ['dotenv/config'],
  setupFilesAfterEnv: ['<rootDir>/tests/setupAfterEnv.js']
};
