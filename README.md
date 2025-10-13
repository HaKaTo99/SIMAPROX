<div align="center">
	<h1>SIMAPRO Enterprise</h1>
	<p>Enterprise Project & Work Management Platform (Primavera P6 + Monday.com + ClickUp + OpenProject Fusion)</p>
	<sup>Version 1.0.0</sup>
</div>

## 🚀 Overview
SIMAPRO Enterprise adalah sistem manajemen proyek dan pekerjaan tingkat enterprise dengan fitur:
* Portfolio & Program Management (EPS hierarchy)
* Advanced Scheduling (CPM, baseline, dependencies)
* Earned Value & Financial Tracking
* Resource & Capacity Management
* Modern Task Management (boards, workspaces, custom fields)
* Time Tracking & Collaboration (comments, attachments)
* AI Predictions & Advanced Reporting
* Workflow & Approvals Engine

## ⚡ Quick Start (Dev 60 Detik)
```
git clone <repo>
cd simapro-enterprise
npm install
npm run db:reset   # migrate + seed + seed-admin (sysadmin + admin)
npm run dev        # backend + frontend paralel
```
Buka: http://localhost:3000  → Login: `admin / Admin@123`

Ganti admin cepat:
```
# PowerShell contoh
$env:SEED_ADMIN_USERNAME='hendra'
$env:SEED_ADMIN_EMAIL='hendra@example.com'
$env:SEED_ADMIN_PASSWORD='Rahasia@123'
npm run seed:admin
```

## 🧭 Mode Database
| Mode | Perintah | Kapan Dipakai |
|------|----------|---------------|
| Dev Cepat | `npm run db:reset` | Fitur harian, iterasi cepat |
| Enterprise Penuh | `npm run enterprise:setup` | Staging, demo, uji performa |

Mode Dev: struktur minimal + cepat. Mode Enterprise: pakai schema SQL lengkap (indeks & constraint penuh). Jangan campur tanpa reset.

### ♻️ Idempotensi Enterprise Setup
Perintah `npm run enterprise:setup` sekarang aman dijalankan berulang:
* Menjalankan ulang schema: bagian trigger memakai guard (IF NOT EXISTS) sehingga tidak error jika sudah ada.
* Seed enterprise: dilewati otomatis bila company dengan `code=SMPR` sudah ada (log: "melewati seed enterprise").
* `seed-admin`: membuat / memperbarui admin tanpa memicu duplicate key (gunakan `SEED_ADMIN_COMPANY_CODE` untuk memilih company target, default `MAIN`).

Contoh override company admin ke company seed enterprise:
```powershell
$env:SEED_ADMIN_COMPANY_CODE='SMPR'
npm run enterprise:setup
```

Jika hanya ingin memperbarui password admin tanpa menyentuh schema:
```powershell
$env:SEED_ADMIN_PASSWORD='NewStrong@2025'; npm run seed:admin
```

Guard produksi: pakai `FORCE_ADMIN_PASSWORD=1` + `ALLOW_FORCE_ADMIN_PROD=1` bila perlu memaksa reset di production.

Best Practice:
1. Jalankan `enterprise:setup` sekali di lingkungan baru.
2. Gunakan migrasi incremental JS hanya untuk perubahan ringan sebelum di-port ke file SQL utama.
3. Simpan perubahan struktural final ke `database/simapro_enterprise_db.sql` dan pastikan idempotent (IF NOT EXISTS / DO blocks).


## 🔐 Rotasi Password Admin (Opsional)
Paksa update password admin (user sudah ada):
```
$env:SEED_ADMIN_USERNAME='admin'
$env:SEED_ADMIN_PASSWORD='BaruKuat@2025'
$env:FORCE_ADMIN_PASSWORD='1'
npm run seed:admin
```
Guard produksi: butuh `ALLOW_FORCE_ADMIN_PROD=1` agar update dijalankan di `NODE_ENV=production`.

### 🔄 Batch Reset Banyak User (Enterprise Seed)
Jika memakai seed SQL enterprise, password plaintext beberapa user tidak diketahui. Gunakan utilitas batch:

Reset semua ke satu password:
```
$env:USERS="sysadmin,jdoe,asmith";
$env:NEW_PASSWORD="ChangeMe!2025";
npm run reset:passwords
```

Generate random unik per user (ditampilkan sekali di console):
```
$env:USERS="sysadmin,jdoe,asmith";
$env:RANDOM_PASSWORDS="1";
npm run reset:passwords
```

Dry run (lihat apa yang akan terjadi tanpa mengubah DB):
```
$env:USERS="sysadmin,jdoe"; $env:NEW_PASSWORD="Test@123"; $env:DRY_RUN=1; npm run reset:passwords
```

Produksi diblok by default – butuh:
```
$env:ALLOW_IN_PRODUCTION=1; npm run reset:passwords
```

Env opsional lain:
* `PASSWORD_LENGTH` (default 16) saat RANDOM_PASSWORDS=1

Output akan menampilkan tabel status: updated / not_found / dry_run. Simpan password random segera (tidak akan dicetak ulang).

## 🩺 Troubleshooting Cepat
| Gejala | Penyebab Umum | Solusi Singkat |
|--------|---------------|----------------|
| 401 login | Password/username salah | Cek seed admin output |
| 403 /auth/me | Belum login / token invalid | Login ulang / periksa base URL frontend |
| 403 fitur (risk/dashboard) | Role tanpa permission | Pakai akun admin / periksa role mapping |
| Crash requirePermission | Import salah | Gunakan `{ requirePermission } = ...` |
| Seed gagal kolom code | Versi seed lama | Jalankan patch terbaru / db:reset |

## 💳 Pricing & Plans (Tiering)
Platform mendukung 3 tier paket utama dengan gating via kolom `companies.current_plan_code`, tabel `plan_types`, dan middleware `requirePlan` / `requireFeature`.

| Plan | Target | Limit Pengguna | Storage | Contoh Fitur Inti | Fitur Terkunci (Perlu Upgrade) |
|------|--------|----------------|---------|-------------------|---------------------------------|
| FREE (UMKM) | Freelancer, Tim ≤10 | 10 (+bonus referral) | 5 GB | Task, Basic Kanban, Basic Gantt, Invoice basic | CPM advanced, Resource Allocation, API, Risk, AI Predictive |
| SME | Perusahaan Menengah (≤250) | 250 | 50–100 GB | Semua FREE + CPM advanced, Resource Allocation, Cost/Budget, Dashboard interaktif, API | Risk module, AI predictive, Multi-currency, SSO |
| ENT (Enterprise) | Korporasi, Multi-cabang | Unlimited | Unlimited + DR | Semua SME + Risk module, AI predictive, Workflow automation, Multi-branch, SSO, Audit enhanced | — |

Hierarki plan: FREE < SME < ENT.

### Tabel Baru (Migrasi)
`plan_types`, `company_subscriptions` serta kolom `companies.current_plan_code`.

### Registri Fitur
`backend/src/services/plan/featureRegistry.js` mendefinisikan mapping `featureKey -> { minPlan }`.

Contoh:
```js
resource_allocation: { minPlan: 'SME' },
risk_module: { minPlan: 'ENT' }
```

### Middleware
* `requirePlan('SME')` → blokir jika company masih FREE.
* `requireFeature('cpm_advanced')` → cek minPlan dari registry.

### Endpoint Plan Info
`GET /api/plans/current` → mengembalikan:
```json
{
	"success": true,
	"data": {
		"plan": "FREE",
		"planDetail": { "code": "FREE", "max_users": 10, ... },
		"features": ["basic_tasks","basic_kanban",...],
		"quota": { "maxUsers": 10, "usersUsed": 3, "storageQuotaMb": 5120, "storageUsedBytes": 204800 }
	}
}
```
Gunakan di frontend untuk mengatur toggling UI (misal sembunyikan menu Risk jika tidak ada `risk_module`).

### Quota Enforcement
Middleware: `enforceQuota('users')` dan `enforceQuota('storage')`.
Contoh integrasi:
* POST /api/users → cek jumlah user vs `plan_types.max_users`.
* Upload attachment → cek total ukuran (sum file_size) vs `storage_quota_mb`.

Error:
```json
{
	"success": false,
	"message": "Kuota pengguna tercapai",
	"code": "PLAN_QUOTA",
	"details": { "max": 10, "used": 10 }
}
```
Atau untuk storage:
```json
{
	"success": false,
	"message": "Kuota storage tercapai",
	"code": "PLAN_QUOTA",
	"details": { "maxMb": 5120, "usedBytes": 5368709120 }
}
```

### Frontend Integrasi Plan & Fitur
Frontend memuat data plan saat bootstrap setelah auth sukses:
1. `planSlice` di `frontend/src/store/slices/planSlice.ts` mengekspor thunk `fetchCurrentPlan`.
2. `App.tsx` memasukkan bootstrap komponen yang memanggil thunk sekali token tersedia.
3. Selector penting:
	 * `selectPlanState` → object penuh `{ plan, planDetail, features, quota, loading }`
	 * `selectPlanCode` → string plan saat ini (`FREE|SME|ENT`)
	 * `selectHasFeature(name)` → boolean
4. Contoh gating di UI (lihat `components/Layout/Layout.tsx`): menu "Advanced Scheduling" hanya muncul jika fitur `cpm_advanced` tersedia.

Snippet cepat:
```tsx
import { useSelector } from 'react-redux';
import { selectHasFeature } from '@/store/slices/planSlice';

export function AdvancedSchedulingButton() {
	const enabled = useSelector(selectHasFeature('cpm_advanced'));
	if (!enabled) return null;
	return <button>Run CPM</button>;
}
```

Quota di UI (opsional):
```tsx
const { quota } = useSelector(selectPlanState);
const inviteDisabled = quota && quota.usersUsed >= quota.maxUsers;
```
Selalu tetap validasi di backend—UI hanya untuk UX preventif.

### Menambah Fitur Plan Baru
1. Tambahkan definisi fitur di registri backend (`featureRegistry.js`) dengan `minPlan`.
2. Tambah ke seed plan (atau update row `plan_types.features` JSONB) bila ingin fitur dimiliki plan tertentu.
3. Gate endpoint dengan `requireFeature('nama_fitur')` atau `requirePlan('SME')`.
4. Tambahkan test: satu sukses (plan memenuhi), satu gagal (plan di bawah).
5. Gunakan `selectHasFeature('nama_fitur')` untuk gating komponen UI.

### Error Codes Relevan (Frontend Handling)
| Code | Arti | Tindakan UI |
|------|------|-------------|
| PLAN_LIMIT | Plan di bawah minimum | Tampilkan upsell modal / link upgrade |
| FEATURE_DISABLED | Fitur tidak tersedia untuk plan | Sembunyikan atau tampilkan badge terkunci |
| PLAN_QUOTA | Kuota tercapai | Disable aksi + CTA upgrade |

Tangani dengan interceptor axios: jika `code` termasuk daftar di atas, munculkan notifikasi terarah.


### Contoh Gating (Scheduling Routes)
`recalculate-cpm` & `level-resources` diberi middleware plan/feature agar FREE tidak mengakses CPM advanced atau resource leveling.

### Seed Plans
Migrasi seed otomatis memasukkan: FREE, SME, ENT dan mengisi `current_plan_code='FREE'` bagi company yang belum punya plan.

### Quota (Extension)
Quota pengguna & storage dapat ditegakkan dengan menambah middleware `enforceQuota(metric)` (belum diaktifkan default). Rencana: agregasi usage harian di `company_usage`.

### Upgrade / Downgrade (Roadmap)
* Upgrade: set `current_plan_code` + buat record `company_subscriptions`.
* Downgrade terjadwal: status subscription → efektif di `period_end`.
* Grace period: set status `grace` (read-only mutasi tertentu).

### Error Codes
* `PLAN_LIMIT` – plan tidak memenuhi minPlan.
* `FEATURE_DISABLED` – fitur tidak tersedia di plan saat ini.
* `FEATURE_UNKNOWN` – key fitur tidak terdaftar.

### Next (Future)
* Billing gateway (Midtrans/Stripe) → generate invoice & webhook update subscription.
* Quota storage & user realtime.
* Multi-currency & SSO modul enterprise.

## 🧩 Role Superuser Konsolidasi
Role resmi: `System Administrator` (skrip seedAdmin akan rename role lama `System Admin` jika ada). Pastikan hanya satu entry wildcard `*`.


## 🗂 Project Structure
```
simapro-enterprise/
	backend/                  # Node.js + Express API (security + metrics + rotating refresh)
		src/
			routes/               # auth, users, dashboard, risk, ...
			utils/                # migrate, seed, authTokens, metrics, tokenCleanup
			middleware/           # authenticate, etc.
	frontend/                 # React (CRA) + TS + Redux Toolkit + AntD
		src/
			store/slices/authSlice.ts
			utils/jwt.ts
	docker-compose.yml        # Postgres + backend + frontend
	package.json (root)       # concurrent dev scripts
	database/
		simapro_enterprise_db.sql
		simapro_enterprise_seed.sql
```

## ⚙️ Backend (Node.js + Express)
Key folders:
* `src/config` (database pool)
* `src/utils` (migrate/seed scripts - basic; for full enterprise use .sql files)
* `src/middleware` (auth, validation)
* `src/routes` (auth, users, companies, portfolios, projects, tasks, resources, reports, dashboard)

### Core Scripts
| Script | Description |
|--------|-------------|
| `npm run dev` | Start backend in watch mode (nodemon) |
| `npm run migrate` | Jalankan migrasi dasar (tabel inti sederhana) |
| `npm run seed` | Seed dasar (roles + sysadmin) |

Untuk skema enterprise gunakan file SQL di folder `database/` (lihat bagian Database Setup).

### Auth & Sessions
Endpoints:
* `POST /api/auth/login`
* `POST /api/auth/token` (rotate & issue access token)
* `POST /api/auth/logout`
* `POST /api/auth/logout-all`
* `GET /api/auth/me`
* `GET /api/auth/sessions`
* `POST /api/auth/sessions/revoke`
* `POST /api/auth/sessions/revoke-others`

Fitur:
* Rotating refresh (hashed SHA-256 di DB)
* Scheduler cleanup expired/revoked (grace configurable)
* Session listing & selective revoke

### Standar Respon API
Sukses:
```json
{
	"success": true,
	"message": "OK",
	"data": {},
	"meta": { "page":1 }
}
```
Error:
```json
{
	"success": false,
	"message": "Invalid credentials",
	"code": "INVALID_CREDENTIALS",
	"details": {}
}
```
Kode umum: `BAD_REQUEST`, `INVALID_CREDENTIALS`, `USER_INACTIVE`, `AUTH_REQUIRED`, `FORBIDDEN`, `NOT_FOUND`, `DUPLICATE_CODE`, `CONFIG_ERROR`, `INTERNAL_ERROR`.

Helper: `src/utils/response.js`.

### Error Handling
`ApiError` (`src/utils/errors.js`) memberi struktur (status, code, details). Global error handler akan mengubah ke format standar bila ada throw atau error tak terduga.

### Logging
Menggunakan `pino` dengan request ID otomatis. Setiap request dicatat (method, url, status, duration). Dapat diarahkan ke pipeline ELK / Loki / OpenTelemetry.

### Metrics (Prometheus)
Endpoint: `GET /api/metrics`
Custom metrics:
* `simapro_http_request_duration_seconds{method,route,status}`
* `simapro_http_requests_total{method,route,status}`
* `simapro_http_request_errors_total{method,route,status}`
* `simapro_http_requests_in_flight`
* `simapro_db_query_duration_seconds{operation,success}`
* `simapro_db_query_errors_total{operation}`
Route disanitasi (angka & UUID -> `:id`).

Contoh konfigurasi Prometheus:
```yaml
scrape_configs:
	- job_name: 'simapro'
		static_configs:
			- targets: ['localhost:5000']
		metrics_path: /api/metrics
```

### Health Check
`GET /api/health` -> status server + koneksi database (OK / DEGRADED).

### Swagger
`/api-docs` OpenAPI 3 (anotasi JSDoc mencakup sessions & risk).

## 🎨 Frontend (React + CRA + Ant Design)
Highlights:
* React 18 + TypeScript (CRA)
* Redux Toolkit store (auth slice with preemptive refresh scheduling)
* Axios with queued token rotation & global error interceptor
* Ant Design 5 + Recharts
* ProtectedRoute bootstrap `/auth/me`

Menjalankan frontend dev:
```
cd frontend
npm install
npm start
```

## 🗄 Database Setup (Enterprise Schema)
Opsi 1 (Cepat – baseline minimal):
```
cd backend
npm run migrate
npm run seed
```

Opsi 2 (Full Enterprise Schema + Seed):
```
psql -U postgres -d simapro_enterprise -f database/simapro_enterprise_db.sql
psql -U postgres -d simapro_enterprise -f database/simapro_enterprise_seed.sql
```
Catatan: Password hash di seed menggunakan bcrypt cost 10 (dummy). Ganti pada production.

### 🔌 Menggunakan Database Eksternal / Pre-seeded
Jika sudah ada instance PostgreSQL dengan data (misal DB `simaproxen`) dan tidak ingin reset:
1. Sesuaikan `.env` backend:
	```
	DB_HOST=localhost
	DB_PORT=5432
	DB_NAME=simaproxen
	DB_USER=postgres
	DB_PASSWORD=<password_eksisting>
	```
2. Jalankan migrasi additive (idempoten):
	```powershell
	npm run migrate
	```
	Migrasi akan: menambah kolom hilang, deduplikasi `(company_id,name)` pada `roles`, menambahkan constraint unik bila belum ada.
3. Reset password user penting agar diketahui:
	```powershell
	$env:USERS="sysadmin,admin"; $env:NEW_PASSWORD="ChangeMe!2025"; npm run reset:passwords
	```
	atau random per user:
	```powershell
	$env:USERS="sysadmin,admin"; $env:RANDOM_PASSWORDS="1"; npm run reset:passwords
	```
4. Start backend. Jika port 5000 terpakai, server otomatis pindah 5001/5002 — perbarui base URL frontend (atau kosongkan port 5000).
5. Verifikasi health:
	```powershell
	Invoke-WebRequest -UseBasicParsing http://localhost:5001/api/health | Select -ExpandProperty Content
	```
6. Login dengan user yang di-reset.

Troubleshooting:
| Gejala | Penyebab | Solusi |
|--------|----------|--------|
| 28P01 password authentication failed | Password tidak sinkron | Samakan `.env` atau reset password DB |
| 42P07 constraint already exists | Constraint sudah ada | Abaikan; migrasi idempoten aman |
| Port in use, trying next | Port 5000 digunakan proses lain | Pakai port fallback atau bebaskan 5000 |
| 401 login | Password lama tak diketahui | Jalankan reset:passwords |

Best Practice:
* Buat user DB khusus aplikasi (bukan `postgres`).
* Normalkan role lama "System Admin" → "System Administrator".
* Hindari jalankan seed SQL enterprise di atas data aktif.

### Penting
Jika pakai schema enterprise SQL, Anda bisa menonaktifkan migrasi sederhana JS atau memisahkan dengan prefix (misal `legacy_`).

## 🔐 Environment Variables (Backend)
Contoh `.env`:
```
NODE_ENV=development
PORT=5000
CORS_ORIGINS=http://localhost:3000
FRONTEND_URL=http://localhost:3000
DB_HOST=localhost
DB_PORT=5432
DB_NAME=simapro_enterprise
DB_USER=postgres
DB_PASSWORD=your_password
JWT_SECRET=replace_with_strong_secret
ACCESS_TOKEN_EXPIRES=15m
REFRESH_TOKEN_EXPIRES_DAYS=7
REFRESH_TOKEN_ROTATE=true
REFRESH_CLEAN_INTERVAL_MS=900000
REFRESH_REVOKED_GRACE_HOURS=12
UPLOAD_PATH=./uploads
MAX_FILE_SIZE=10485760
```
Frontend `.env`:
```
VITE_API_URL=http://localhost:5000/api
```

## 🐳 Docker & Dev Scripts
Compose:
```
docker compose up -d --build
```
Services: database (Postgres 15), backend (Express), frontend (Nginx serving CRA build).

Dev tanpa container (hot reload):
```
npm install
cd backend && npm install
cd ../frontend && npm install
cd ..
npm run dev
```

## 🚦 Permissions & Roles
Seed dasar: System Administrator, Project Manager, Team Member. Seed enterprise menambahkan Portfolio Manager, Team Lead, Executive Viewer. Ekspansi disarankan: endpoint CRUD roles & assignment, caching permission matrix.

## 📈 Indeks & Kinerja
Enterprise schema sudah mencakup indeks utama (lihat bagian INDEXES dalam `simapro_enterprise_db.sql`). Untuk baseline sederhana (JS migrate) belum semua dibuat — gunakan schema lengkap untuk dataset besar.

## 🧪 Testing
Backend (Jest + Supertest): auth flow, sessions lifecycle, dashboard, metrics, health.
Frontend (CRA Jest): auth slice reducer, JWT decode & expiry.

### Test Auth Helper (Backend)
File: `backend/src/tests/testAuthHelper.js`
- Registers a fresh company + user
- Creates a role and attaches requested permissions
- Logs in via real `/api/auth/login` to obtain a valid JWT (accessToken)
- Use in tests to avoid brittle manual token stubs

Usage example inside a test:
```js
const { createUserWithPermissions } = require('./testAuthHelper');
const { token } = await createUserWithPermissions({ permissions: ['issue.manage','issue.read'] });
await request(app).get('/api/issues').set('Authorization', `Bearer ${token}`);
```

### Environment Configuration Validation
Early startup validation ensures required variables exist. Implemented in `configValidation.js` and invoked from `server.js` before database initialization. Missing critical env vars cause fail-fast with explicit error.

Required (current minimal set): `JWT_SECRET (or JWT_SECRETS), DB_HOST, DB_PORT, DB_NAME, DB_USER, DB_PASSWORD`.

### Risk Scoring Cache
Endpoint `/api/risk/activities` now cached (30s TTL) keyed by `eps_id` + `limit`. Response includes header `X-Cache: HIT|MISS` for observability. Use to reduce repeat scoring cost in dashboards.

### Additional Permission Seeding
Seed script (`seed.js`) now guarantees critical granular permissions (`issue.read`, `issue.manage`, `risk.view`, `report.export`, `feature_flag.manage`) exist and are bound to `System Administrator` role to future-proof removal of wildcard `*`.

Commands:
```
npm run test:backend
npm run test:frontend
npm test
```

## ✅ Quality Gates
Backend:
```
cd backend
npm run lint              # ESLint (no warnings allowed)
npm run test              # Jest unit/integration
npm run test:coverage     # Enforce coverage thresholds (statements>=55, branches>=35, functions>=45, lines>=55)
npm run build             # Lint + (no transpile needed, pure Node.js)
```
Frontend:
```
cd frontend
npm run build             # CRA production build
npm test                  # Component/unit tests
```
Aggregate (root scripts suggestion – can be added later):
```
npm run dev               # Concurrent backend + frontend dev
```
CI Recommendation:
1. Install deps (backend + frontend)
2. Run backend lint & coverage
3. Run frontend build & tests
4. (Optional) Build & start docker-compose, curl /api/health & /api/metrics

Planned Increment: raise coverage gates after adding domain logic & tests (target mid-term: statements 70+, branches 55+, functions 65+, lines 70+).

## 🛡 Hardening Status
Implemented:
* Global + granular rate limit (login, token)
* Helmet CSP & strict CORS whitelist
* Rotating refresh tokens (hashed) + session revoke endpoints
* Token cleanup scheduler
* Pino logging + request IDs
* Prometheus HTTP & DB metrics

### 🔎 Health vs Readiness
Endpoint `GET /api/health` memberikan status dasar (OK / DEGRADED) dan selalu mencoba merespon 200/500 untuk monitoring manusia.
Endpoint `GET /api/readiness` digunakan oleh orkestrator / load balancer: hanya mengembalikan 200 jika semua dependency wajib siap (DB reachable, env lengkap, memori tidak melewati ambang peringatan). Bila ada masalah ia mengembalikan 503 `NOT_READY` sehingga instance dapat dikeluarkan dari rotasi.

Contoh sukses:
```json
{
	"success": true,
	"message": "Service ready",
	"data": {
		"status": "READY",
		"timestamp": "2025-10-05T01:23:45.000Z",
		"uptime": 123.45,
		"database": { "ok": true },
		"memory": { "rssMb": 142 },
		"issues": []
	}
}
```
Contoh tidak siap (503):
```json
{
	"success": false,
	"message": "Service not ready",
	"code": "NOT_READY",
	"details": {
		"status": "NOT_READY",
		"database": { "ok": false, "detail": "connection timeout" },
		"issues": ["database_unreachable"],
		"memory": { "rssMb": 650 }
	}
}
```
Gunakan variabel `READINESS_RSS_WARN_MB` untuk menyesuaikan ambang memori (default 600 MB).

Next (roadmap): audit trail, feature flags, encryption at rest, advanced secret rotation (as multi-secret now implemented for JWT access tokens).

### 🔐 JWT Secret Rotation (Multi-Secret Access Tokens)
Environment now supports `JWT_SECRETS` (preferred) or legacy `JWT_SECRET`.

Usage (comma list):
```
JWT_SECRETS=newSecret2025Q1_superlongentropyvalue,prevSecret2024Q4_anotherlongvalue,legacyInitial
```
or JSON array:
```
JWT_SECRETS=["newSecret2025Q1_superlongentropyvalue","prevSecret2024Q4_anotherlongvalue","legacyInitial"]
```
Rules:
1. First secret = used to SIGN new access tokens.
2. All secrets in the list are tried for VERIFICATION (old unexpired tokens keep working).
3. Each token carries a short `kid` header (hash prefix) to fast-path verification.
4. Weak secrets (<32 chars) trigger a startup warning.
5. Duplicates are ignored (first occurrence kept).

Rotation Procedure:
1. Generate new strong secret (>=32 chars, high entropy).
2. Prepend to `JWT_SECRETS` keeping previous secrets after it.
3. Deploy – new tokens use the new secret; old tokens still validate.
4. After max access token TTL has elapsed (default 15m) and a safety window, remove the oldest secret(s).

Migration from legacy `JWT_SECRET`:
1. Set `JWT_SECRETS=<new>,<oldLegacy>` while leaving old `JWT_SECRET` (optional).
2. Remove `JWT_SECRET` variable (optional cleanup) – application now relies solely on list.
3. Eventually drop `<oldLegacy>` when safe.

### 🧹 Log Sanitization
Middleware now redacts sensitive request data BEFORE logging:
* Authorization header token value → `Bearer [REDACTED]`
* Body fields: `password`, `currentPassword`, `newPassword`, `refreshToken` → `[REDACTED]`
* Query params: `token`, `access_token` → `[REDACTED]`

Extend by editing sanitization middleware in `backend/src/app.js` if you introduce new sensitive keys.

## 🕵️ Audit Trail
Audit Trail merekam peristiwa penting untuk kepatuhan & forensik. Saat ini logging eksplisit dipanggil pada layer layanan / routes.

Tabel: `audit_events`
Kolom utama: `id, company_id, user_id, action, entity_type, entity_id, meta (JSONB), created_at, request_id`

Endpoint:
* `GET /api/audit` — Parameter filter opsional:
	* `action` (exact match, contoh: `comment.create`)
	* `entity_type` (activities|kanban_cards|eps|wbs|resources|comments|attachments)
	* `entity_id` (numeric)
	* Pagination: `limit` (default 50, max 200), `offset`

Contoh Response:
```json
{
	"success": true,
	"data": [
		{
			"id": 123,
			"action": "comment.create",
			"entity_type": "activities",
			"entity_id": 45,
			"meta": { "comment_id": 77 },
			"user_id": 9,
			"created_at": "2025-01-04T12:00:00.000Z"
		}
	],
	"meta": { "count": 50, "nextOffset": 50 }
}
```

Action Saat Ini:
* `comment.create` / `comment.update` / `comment.delete`
* `attachment.upload` / `attachment.delete`

Konvensi Penamaan Action: `<domain>.<verb>` (hindari tense plural). Domain bisa bertingkat (misal `resource.capacity.recalc`).

Strategi Ke Depan:
1. Tambah middleware generik utk auto-log (misal header `x-audit-action` atau dekorator route)
2. Ekstensi domain: scheduling baseline perubahan, role/permission mutasi, cost ledger posting, EVM period close
3. Retention & export (CSV / NDJSON) + checksum chain (opsional) untuk deteksi tampering
4. Integrasi ke sistem SIEM eksternal (webhook / Kafka / syslog) bila diperlukan

Catatan Kinerja: Index pada `(company_id, created_at)` dan `(entity_type, entity_id)` mendukung query time-ordered & drill-down entitas. Gunakan pagination berbasis offset; dapat ditingkatkan ke keyset (WHERE created_at < last_seen) bila volume >10M rows.

## 🔀 Feature Flags (Rencana Implementasi)
Tujuan: Mengaktifkan/menonaktifkan fitur per-tenant (company) atau global rollout bertahap (percentage rollout) tanpa redeploy.

Baseline MVP (Tahap 1):
Tabel `feature_flags`:
```
id PK
key VARCHAR(100) UNIQUE -- ex: scheduling_advanced, audit_export
description TEXT
enabled_global BOOLEAN DEFAULT false
rollout_pct INT NULL -- 0-100 optional
created_at, updated_at
```
Tabel `company_feature_flags` (override per company):
```
company_id FK -> companies
flag_id FK -> feature_flags
enabled BOOLEAN -- explicit override
PRIMARY KEY(company_id, flag_id)
```

Service API:
* `isFlagEnabled(companyId, key)` -> boolean (logic: if override exists use override; else if enabled_global true and (rollout_pct null OR hash(companyId)%100 < rollout_pct) then true else false)
* Cache in-memory (LRU + TTL 60s) & warm on startup.

Endpoints (admin scope):
* `GET /api/flags` (list)
* `POST /api/flags` (create)
* `PATCH /api/flags/:key` (edit properties: enabled_global, rollout_pct, description)
* `PUT /api/flags/:key/companies/:companyId` (set override)
* `DELETE /api/flags/:key/companies/:companyId` (remove override)

Middleware:
`requireFlag('key')` -> 403 kalau tidak aktif.

Persisted Audit:
Setiap perubahan flag & override dicatat ke `audit_events` dengan action `flag.update` / `flag.override.set` / `flag.override.remove`.

Client Side (Frontend):
Bootstrap endpoint `/api/flags/enabled` mengembalikan daftar key aktif untuk user -> simpan di redux; gating UI (misal modul EVM lanjutan, export, AI). Refresh berkala (interval 5 menit) atau saat user navigasi besar.

Tahap 2:
* Targeting rules (expression JSON: role in [...], plan_tier, created_at < date)
* Segment pre-compute & caching redis
* A/B variant (allocation buckets) + metrics exposure

Tahap 3:
* Real-time toggle via WebSocket event broadcast
* Canary progressive rollout automation (increase pct if error rate < threshold)

### Status Implementasi (Saat Ini)
Sudah tersedia (MVP):
* Tabel `feature_flags` & `company_feature_flags`
* Service dengan cache 60s + hash deterministik untuk rollout persentase
* Endpoint:
	* `GET /api/flags` (list)
	* `POST /api/flags` (create)
	* `PATCH /api/flags/:key` (update)
	* `PUT /api/flags/:key/companies/:companyId` (set override)
	* `DELETE /api/flags/:key/companies/:companyId` (hapus override)
	* `GET /api/flags/enabled` (daftar aktif untuk company caller)
	* `GET /api/flags/:key/check` (boolean per key)
* Audit events: `flag.create`, `flag.update`, `flag.override.set`, `flag.override.remove`

Contoh enable global:
```bash
curl -H "Authorization: Bearer <token>" -X PATCH \
	-H "Content-Type: application/json" \
	-d '{"enabled_global":true}' \
	http://localhost:5000/api/flags/scheduling_advanced
```

Rencana berikutnya: integrasi permission matrix dan dekorator / middleware `requireFlag('key')` ke endpoint modul baru.

## 🛡 Permission Matrix (RBAC)
Model saat ini: Roles ↔ Permissions (many-to-many) + User ↔ Roles. Tidak ada grant langsung user-permission (sederhana, mudah cache).

Tabel:
* `roles` (sudah ada)
* `permissions` (key unik, deskripsi)
* `role_permissions` (role_id, permission_id)
* `user_roles` (user_id, role_id)

Service Cache:
`permissionsService` memuat semua permissions + mapping role→permissions sekali, invalidasi saat perubahan (assign/revoke/create). User permissions di-cache per user 60s (TTL dapat dituning via env di masa depan).

Middleware:
`requirePermission('feature_flag.manage')` → 403 dengan code `NO_PERMISSION` jika user belum memiliki permission.

Contoh Penggunaan (Route):
```js
router.post('/api/flags', authenticateToken, requirePermission('feature_flag.manage'), handler)
```

Menambah Permission Baru (sementara via SQL / service):
```sql
INSERT INTO permissions(key, description) VALUES ('report.export','Export laporan');
-- Assign ke role Project Manager (id 3 contoh)
INSERT INTO role_permissions(role_id, permission_id)
SELECT 3, p.id FROM permissions p WHERE p.key='report.export';
```

Roadmap Lanjutan:
1. Permission grouping & wildcard (`report.*`)
2. Scope level (per EPS / per project) dengan tabel tambahan `scoped_role_assignments`
3. Policy evaluation caching Redis (cluster scale)
4. UI matrix editor & audit otomatis (`permission.assign` / `permission.revoke`)

Integrasi Berikutnya:
* Export / Reporting endpoints → `report.export`
* Audit export → `audit.export`
* Scheduling advanced toggle + permission gating → `scheduling.advanced.use`

## 🧩 Roadmap (Ringkas)
1. Domain model & feature mapping (projects/tasks/dependencies/resources)
2. Scheduling engine (CPM, baseline operations)
3. Kanban & Agile module
4. Cost & RAB (EVM integration)
5. Resource workload analytics
6. Collaboration layer (comments, docs, mentions)
7. Audit trail & activity log
8. Reporting & export
9. Feature flags (modular enable/disable per tenant)
10. Security enhancements phase
11. External integrations (M365, Slack, GitHub, Zoom)
12. Mobile/offline (PWA + sync queue)
13. i18n & localization
14. Dark mode & accessibility
15. AI predictive models

## 👤 Default Credentials
```
username: sysadmin
password: password
```
Override password seeding: set env `SEED_ADMIN_PASSWORD` sebelum menjalankan seed.

## 📚 API Docs
http://localhost:5000/api-docs

## 🤝 Contributing
1. Fork & branch
2. Commit terarah (feat:, fix:, docs:, chore:)
3. Pull request dengan deskripsi jelas

## 📝 License
MIT (tambahkan file LICENSE bila belum ada)

---
> Dokumentasi ini mencerminkan status baseline + security & observability. Gunakan schema SQL enterprise untuk skala produksi & aktifkan modul lanjutan bertahap.

---

## 🐞 Issues Management / Manajemen Isu

**EN:** The Issues module provides a lightweight cross-entity tracking system (risks, bugs, blockers) linked optionally to core entities (activities, WBS, EPS, resources, kanban cards). Supports status, priority, assignment, labels, and audit logging (future extension).

**ID:** Modul Issues menyediakan pelacakan ringan lintas entitas (risiko, bug, blocker) yang dapat dihubungkan secara opsional ke entitas inti (activities, WBS, EPS, resources, kanban cards). Mendukung status, prioritas, penugasan, label, dan bisa diperluas ke audit.

### Table Schema (Ringkas)
```
issues(
	id BIGSERIAL PK,
	company_id FK,
	entity_type VARCHAR(50) NULL,
	entity_id BIGINT NULL,
	title VARCHAR(250) NOT NULL,
	description TEXT,
	status VARCHAR(40) DEFAULT 'open',
	priority VARCHAR(20) DEFAULT 'medium',
	assignee_user_id INT NULL,
	reporter_user_id INT NULL,
	labels TEXT[],
	due_date DATE,
	created_at, updated_at, closed_at
)
```

### Status Values / Nilai Status
`open | in_progress | resolved | closed`

### Priority Values / Nilai Prioritas
`low | medium | high | critical`

### Endpoints
| Method | Path | Description (EN) | Deskripsi (ID) | Permission |
|--------|------|------------------|----------------|------------|
| GET | `/api/issues` | List issues (filterable) | Daftar issues (bisa difilter) | `issue.read` |
| POST | `/api/issues` | Create new issue | Buat issue baru | `issue.manage` |
| PATCH | `/api/issues/:id` | Update fields/status | Ubah field / status | `issue.manage` |

Query filters (EN/ID): `status`, `priority`, `assignee_user_id`, `entity_type`, `entity_id`, pagination via `limit`, `offset`.

Example Create (EN):
```bash
curl -X POST -H "Authorization: Bearer <token>" -H "Content-Type: application/json" \
	-d '{"title":"Late procurement","priority":"high","entity_type":"activities","entity_id":42}' \
	http://localhost:5000/api/issues
```

Contoh List (ID):
```bash
curl -H "Authorization: Bearer <token>" "http://localhost:5000/api/issues?status=open&priority=high"
```

### Permissions
Seeded automatically: `issue.read`, `issue.manage`. Assign to roles via role_permissions.

---

## 🤖 AI Risk Scoring (Heuristik Awal)

**EN:** A preliminary heuristic risk scoring service (`riskScoringService`) that computes a 0–100 risk score per activity based on criticality, negative float, progress, and planned duration. Intended future replacement with ML (regression/classification) using richer features (variance trends, resource contention, historical slippage).

**ID:** Layanan penilaian risiko heuristik awal (`riskScoringService`) menghitung skor risiko 0–100 per aktivitas berdasarkan critical path, float negatif, progress, dan durasi rencana. Dirancang agar mudah diganti model ML di masa depan (fitur tambahan: tren varian, konflik resource, histori keterlambatan).

### Heuristic (Simplified)
| Condition | Score + |
|-----------|---------|
| Critical path | +30 |
| Negative float | +25 |
| Percent complete < 50% | +15 |
| Planned duration > 20 days | +10 |
| 0% complete AND critical | +10 |

Levels: `low (<30)`, `medium (30-59)`, `high (>=60)`.

### Extensibility / Ekstensibilitas
Add feature extractors → persist snapshots → train offline → export model (ONNX / JSON weights) → load inference service. Provide A/B via feature flag `ai.risk_scoring.v2` later.

### Endpoint (Heuristic Scores) / Endpoint Skor Heuristik
| Method | Path | EN Description | ID Deskripsi | Permission |
|--------|------|----------------|-------------|------------|
| GET | `/api/risk/activities` | List recent activities with heuristic risk score | Daftar aktivitas terbaru dengan skor risiko heuristik | `risk.view` |

Query params: `eps_id` (optional filter), `limit` (max 500, default 100).

Example (EN):
```bash
curl -H "Authorization: Bearer <token>" http://localhost:5000/api/risk/activities
```

Response sample:
```json
{
	"success": true,
	"data": {
		"items": [
			{
				"id": 101,
				"name": "Excavation Phase",
				"wbs_id": 12,
				"eps_id": 4,
				"percent_complete": 15,
				"is_critical": true,
				"total_float_days": -3,
				"duration_planned_days": 25,
				"risk_score": 80,
				"risk_level": "high"
			}
		],
		"count": 1
	},
	"message": "Activity risk scores"
}
```

Catatan (ID): Nilai skor digunakan sebagai indikasi awal. Jangan dipakai untuk keputusan akhir tanpa validasi manajer proyek.

---

## 🌐 Internationalization (i18n)

**EN:** Middleware `i18nMiddleware` loads locale JSON (currently `en`, `id`) and attaches `req.t(key)` translator. Language selection via `Accept-Language` header (first token) with fallback to English.

**ID:** Middleware `i18nMiddleware` memuat file locale JSON (`en`, `id`) dan menambah fungsi `req.t(key)`. Pemilihan bahasa lewat header `Accept-Language` (token pertama), fallback ke English.

Add new locale: create `backend/src/middleware/i18n/locales/<code>.json` and restart server.

---

## 📱 PWA Foundation

**EN:** Frontend includes `manifest.json` and a `serviceWorkerRegistration.ts` stub (registration + unregister). Next steps: offline caching strategy (Workbox), background sync for queued mutations, push notifications integration.

**ID:** Frontend sudah memiliki `manifest.json` dan stub `serviceWorkerRegistration.ts`. Langkah berikut: strategi caching offline (Workbox), sinkronisasi background untuk antrian perubahan, integrasi push notification.

---

## 🔐 Security Enhancements (Extended) / Peningkatan Keamanan

Implemented (EN/ID):
1. AES-256-GCM encryption service (`encryptionService`) – symmetrical encryption helper for sensitive fields (can store version tag for key rotation).
2. Key rotation skeleton (`utils/secrets/rotation.js`) – placeholder managing active/inactive keys (extend with dual-read mode & re-encrypt job).
3. TOTP 2FA scaffold (`twoFactorService`) – secret generation, OTP auth URL, code verify.

Roadmap:
* Dual-key decryption window + background re-encryption
* Encrypted columns (e.g. confidential notes)
* WebAuthn / FIDO2 second factor
* Anomaly detection (velocity / geo / device fingerprint)

---

## 🔌 Integrations (Slack & Email)

**EN:** Basic Slack webhook poster (`slackService`) and email service wrapper (`emailService`) with graceful fallback to logging when SMTP fails. Extend with retry/backoff & provider abstraction (SES, SendGrid) via strategy pattern.

**ID:** Integrasi dasar Slack (webhook poster) dan layanan email wrapper dengan fallback log bila SMTP gagal. Dapat diperluas dengan retry/backoff & abstraksi provider (SES, SendGrid).

---

## 🧮 Dashboard KPI Caching

**EN:** `/api/dashboard/kpi` uses in-memory TTL cache (30s) via `globalCache`. Future: move to Redis cluster for multi-instance consistency.

**ID:** Endpoint `/api/dashboard/kpi` memakai cache TTL in-memory 30 detik. Ke depan: pindah ke Redis agar konsisten antar instance.

---

## 📤 CSV Export (Activities)

**EN:** Streaming CSV export `/api/reports/activities/export.csv` gated by permission `report.export`. Large datasets handled incrementally.

**ID:** Ekspor CSV streaming `/api/reports/activities/export.csv` dilindungi permission `report.export`. Data besar ditangani incremental.

---

## 🧾 Coverage & CI/CD

**EN:** Jest coverage thresholds raised (statements 60 / branches 40 / functions 50 / lines 60). GitHub Actions pipeline: install → migrate → lint → test (coverage) → health smoke.

**ID:** Batas cakupan Jest dinaikkan (statements 60 / branches 40 / functions 50 / lines 60). Pipeline GitHub Actions: install → migrate → lint → test (coverage) → health check.

---

## 🔮 Future Enhancements / Peningkatan Mendatang

| Area | EN (Planned) | ID (Rencana) |
|------|--------------|--------------|
| AI | ML risk model (feature store) | Model ML risiko (feature store) |
| Issues | Comment thread, SLA timers | Thread komentar, SLA timer |
| i18n | Pluralization, runtime hot reload | Pluralisasi, reload runtime |
| Security | WebAuthn, anomaly engine | WebAuthn, mesin anomali |
| Offline | Workbox caching, sync queue | Caching Workbox, antrian sinkronisasi |
| Observability | Trace spans (OpenTelemetry) | Trace span (OpenTelemetry) |
| Flags | Targeting rules & segments | Aturan targeting & segmen |
| Permissions | Scoped/project-level grants | Grant scoped/project-level |
| Reporting | PDF, Excel exports, BI feeds | Ekspor PDF, Excel, feed BI |
| Integrations | JIRA, MS Teams, GitHub PR links | JIRA, MS Teams, tautan GitHub PR |

---

## 🧪 Issues Test Note (EN/ID)
Current integration test includes a simplified auth bypass assumption; adapt to real auth login helper for production test rigor.

Catatan: Test integrasi Issues saat ini memakai asumsi bypass auth sederhana; sesuaikan dengan helper login nyata untuk ketelitian produksi.

## 🏗 Baseline Schema Consolidation (v2025_10)
Seiring banyak migrasi evolusioner, file lama `database/simapro_enterprise_db.sql` tertinggal dari runtime. Versi ter-unifikasi kini tersedia di:

`database/simapro_enterprise_db_v2025_10.sql`

Gunakan ini sebagai baseline baru untuk environment fresh. Untuk database eksisting:
1. Jalankan seluruh migration JS (termasuk `20251005A_consolidation_additive`).
2. Rencanakan migrasi transform (kanban_* → boards/tasks, timesheet_entries → time_entries) sebelum drop tabel lama.
3. Setelah data bersih & verifikasi test hijau, Anda dapat mengganti referensi infra (pipeline / dokumentasi) ke file baseline baru.
4. Jangan langsung mengimpor file baseline baru di atas DB lama tanpa migrasi karena akan kehilangan data / constraint custom.

Compat Views (planned): akan ditambahkan untuk alias `activity_relationships` dan kanban selama masa transisi.

---

## 🔄 Regenerasi Baseline Konsolidasi (v2025_10)
Baseline konsolidasi disimpan di `database/simapro_enterprise_db_v2025_10.sql`. Setiap ada perubahan struktur (melalui migrasi JS baru) yang telah diputuskan menjadi bagian final skema, lakukan regenerasi agar file tetap sinkron.

### Perintah Cepat
```powershell
# Hanya dump (butuh pg_dump di PATH)
npm run baseline:refresh

# Jalankan migrasi (additive) dulu lalu dump
npm run baseline:refresh:migrate
```

Script menjalankan:
1. Koneksi DB berdasarkan env `DB_*` (gunakan DB target yang sudah dimigrasi).
2. (Opsional) Menjalankan `migrate.js` jika memakai var `baseline:refresh:migrate`.
3. Menjalankan `pg_dump -s` (schema only) dengan pengecualian tabel legacy:
	- `kanban_*`, `timesheet_entries`, `activity_baselines`, `wbs_baselines`, `activity_relationships_legacy`, `calendars`, `calendar_exceptions`
4. Normalisasi output (hapus OWNER/ACL, bersihkan komentar header dump internal).
5. Menulis ulang file baseline dengan banner timestamp.

### Best Practice Regenerasi
| Situasi | Tindakan |
|---------|----------|
| Penambahan kolom ringan | Jalankan migrasi JS → verifikasi test → regen baseline |
| Perubahan besar (model baru) | Tambahkan migrasi additive + data transform → setelah stabil regen baseline |
| Penghapusan legacy | Lakukan migrasi cleanup (drop) → regen baseline untuk menghilangkan referensi |

### Guard & Catatan
* File baseline bukan alat upgrade instan untuk DB lama – tetap jalankan migrasi incremental di lingkungan yang sudah punya data.
* Jangan edit manual di tengah (di bawah banner) – perubahan akan ditimpa pada regenerasi berikutnya.
* Pastikan `pg_dump` sesuai versi server untuk menghindari perbedaan sintaks.
* Gunakan branch terpisah saat commit pembaruan baseline agar diff dapat direview (hindari noise tidak relevan terhadap fitur lain).

### Troubleshooting
| Gejala | Penyebab | Solusi |
|--------|----------|--------|
| `pg_dump: command not found` | pg_dump belum terinstall / PATH tidak benar | Install PostgreSQL client tools, tambahkan ke PATH |
| Tabel legacy masih muncul | Cleanup migration belum dijalankan | Jalankan migrasi cleanup, ulangi regen |
| Perbedaan besar yang tidak relevan | Versi pg_dump berbeda atau search_path berbeda | Samakan versi atau set env DB_SCHEMA jika multi-schema |

---


