const fs = require('fs');
const path = require('path');
const { Pool } = require('pg');
require('dotenv').config();

(async () => {
  const pool = new Pool({
    host: process.env.DB_HOST,
    port: process.env.DB_PORT,
    database: process.env.DB_NAME,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD
  });

  const seedPath = path.join(__dirname, '..', 'database', 'simapro_enterprise_seed_v2025_10_copy.sql');
  console.log('Seed path:', seedPath);
  const seedSql = fs.readFileSync(seedPath, 'utf8');

  const client = await pool.connect();
  try {
    console.log('🌱 Menjalankan seed enterprise v2025_10...');
    await client.query('BEGIN');
    await client.query(seedSql);
    await client.query('COMMIT');
    console.log('✅ Seed selesai');
  } catch (err) {
    await client.query('ROLLBACK');
    console.error('❌ Gagal seed:', err.message);
    process.exitCode = 1;
  } finally {
    client.release();
    await pool.end();
  }
})();