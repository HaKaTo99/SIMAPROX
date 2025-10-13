Write-Host "🚀 SIMAPRO Enterprise Setup Script" -ForegroundColor Cyan

# Check Node
if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
  Write-Error "Node.js not installed (need >=18)"; exit 1
}
# Check psql
if (-not (Get-Command psql -ErrorAction SilentlyContinue)) {
  Write-Error "PostgreSQL psql not installed (need >=12)"; exit 1
}

$env:DB_NAME = if ($env:DB_NAME) { $env:DB_NAME } else { 'simapro_enterprise' }

Write-Host "📦 Creating database $($env:DB_NAME) (ignore if exists)"
try { psql -U postgres -c "CREATE DATABASE $($env:DB_NAME);" 2>$null } catch { Write-Host "(skip)" }

Write-Host "📦 Installing backend dependencies"
Push-Location backend; npm install; Pop-Location

Write-Host "📦 Installing frontend dependencies"
Push-Location frontend; npm install; Pop-Location

Write-Host "📁 Creating uploads directory"
New-Item -ItemType Directory -Force -Path backend/uploads | Out-Null

Write-Host "🗄️ Running migrations"
Push-Location backend; npm run migrate; Pop-Location

Write-Host "🌱 Seeding database"
Push-Location backend; npm run seed; Pop-Location

Write-Host "`n🎉 Setup completed" -ForegroundColor Green
Write-Host "Start backend: cd backend; npm run dev"
Write-Host "Start frontend: cd frontend; npm run dev"
Write-Host "Login with sysadmin / password"
