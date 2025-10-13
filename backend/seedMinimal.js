const { query } = require('./src/config/database');

async function seedMinimal() {
  // Insert company if not exists
  await query(`INSERT INTO companies (name, code) VALUES ('Test Company', 'TEST') ON CONFLICT (code) DO NOTHING`);

  // Insert portfolio
  await query(`INSERT INTO portfolios (company_id, name, description, budget_total) VALUES (1, 'Test Portfolio', 'Test portfolio', 1000000) ON CONFLICT DO NOTHING`);

  // Insert eps
  await query(`INSERT INTO eps (portfolio_id, company_id, name, code, description, status) VALUES (1, 1, 'Test Project', 'TEST-PRJ', 'Test project', 'active') ON CONFLICT (code) DO NOTHING`);

  console.log('Minimal seed done');
}

seedMinimal().then(() => process.exit(0)).catch(err => { console.error(err); process.exit(1); });