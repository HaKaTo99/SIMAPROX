require('dotenv').config();
const app = require('./src/app');
const { pool } = require('./src/config/database');
const { initializeDatabase } = require('./src/utils/migrate');
const { logger } = require('./src/utils/logger');
const { scheduleRefreshTokenCleanup } = require('./src/utils/tokenCleanup');
const { validateEnv } = require('./src/utils/configValidation');

let PORT = parseInt(process.env.PORT || '5000', 10);
const MAX_PORT_TRIES = 5;

// Enforce JWT secret presence (avoid fallback in production usage)
if (!process.env.JWT_SECRET || process.env.JWT_SECRET === 'your_super_secure_jwt_secret_key_here_change_in_production') {
  logger.warn('JWT_SECRET is not properly set. Set a strong secret in your environment.');
}

async function startServer() {
  try {
  // Validate environment early
  validateEnv();
  logger.info('Initializing database...');
    await initializeDatabase();

  logger.info('Testing database connection...');
    const client = await pool.connect();
  logger.info('Database connected successfully');
    client.release();

    let attempts = 0;
    const bind = () => {
      const server = app.listen(PORT, () => {
        logger.info({ port: PORT }, 'Server running');
        logger.info({ url: `http://localhost:${PORT}/api-docs` }, 'API Documentation');
        logger.info({ url: `http://localhost:${PORT}/api/health` }, 'Health check');
      });
      server.on('error', (err) => {
        if (err.code === 'EADDRINUSE' && attempts < MAX_PORT_TRIES) {
          logger.warn({ port: PORT }, 'Port in use, trying next');
          attempts += 1;
          PORT += 1;
          setTimeout(bind, 300);
        } else {
          logger.error({ err }, 'Server listen error');
          // eslint-disable-next-line no-process-exit
          process.exit(1);
        }
      });
    };
    bind();

    // Jadwalkan cleanup refresh token (expired / revoked lama)
    scheduleRefreshTokenCleanup();
  } catch (error) {
  logger.error({ err: error }, 'Failed to start server');
  // eslint-disable-next-line no-process-exit
  process.exit(1);
  }
}

process.on('SIGINT', async () => {
  logger.info('Shutting down server (SIGINT)');
  await pool.end();
  // eslint-disable-next-line no-process-exit
  process.exit(0);
});

process.on('SIGTERM', async () => {
  logger.info('Server terminated (SIGTERM)');
  await pool.end();
  // eslint-disable-next-line no-process-exit
  process.exit(0);
});

startServer();
