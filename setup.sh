#!/bin/bash
set -e

echo "🚀 SIMAPRO Enterprise Setup Script"
echo "=================================="

if ! command -v node &> /dev/null; then
  echo "❌ Node.js not installed (need >=18)"; exit 1; fi
if ! command -v psql &> /dev/null; then
  echo "❌ PostgreSQL not installed (need >=12)"; exit 1; fi

echo "✅ Prerequisites OK"

DB_NAME=${DB_NAME:-simapro_enterprise}

echo "📦 Creating database $DB_NAME (ignore if exists)"
createdb "$DB_NAME" 2>/dev/null || echo "(skip)"

echo "📦 Installing backend dependencies"
(cd backend && npm install)

echo "📦 Installing frontend dependencies"
(cd frontend && npm install)

echo "📁 Creating uploads directory"
mkdir -p backend/uploads

echo "🗄️ Running migrations"
(cd backend && npm run migrate)

echo "🌱 Seeding database"
(cd backend && npm run seed)

echo "\n🎉 Setup completed"
echo "Start backend: cd backend && npm run dev"
echo "Start frontend: cd frontend && npm run dev"
echo "Login with sysadmin / password"
