const { Pool } = require('pg');
const fs = require('fs');
const path = require('path');

const envCandidates = [
  path.resolve(__dirname, '../.env'),
  path.resolve(__dirname, '../../.env')
];
for (const p of envCandidates) {
  if (fs.existsSync(p)) {
    require('dotenv').config({ path: p });
    break;
  }
}

function val(name, defVal) {
  const v = process.env[name];
  return (v === undefined || v === '') ? defVal : v;
}

function parsePort(raw) {
  const n = Number(raw);
  if (!Number.isInteger(n) || n <= 0 || n > 65535) {
    console.warn(`[db] Invalid port '${raw}', fallback 5432`);
    return 5432;
  }
  return n;
}

const host = val('PGHOST', val('DB_HOST', 'localhost'));
const port = parsePort(val('PGPORT', val('DB_PORT', '5432')));
const user = val('PGUSER', val('DB_USER', 'postgres'));
const password = String(val('PGPASSWORD', val('DB_PASSWORD', '')));
const database = val('PGDATABASE', val('DB_NAME', 'postgres'));

const pool = new Pool({
  host,
  port,
  user,
  password,
  database,
  max: 10,
  idleTimeoutMillis: 30000
});

pool.on('error', (e) => console.error('[db] idle client error', e.message));

module.exports = { pool };
