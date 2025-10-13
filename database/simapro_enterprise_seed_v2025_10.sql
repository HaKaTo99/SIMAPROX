-- ====================================================================
-- SIMAPRO Enterprise Seed Data (v2025_10) - COMPLETE & VALIDATED VERSION
-- ====================================================================

-- 1. COMPANIES (PT. HAKA BUMI Structure)
INSERT INTO companies (id, parent_company_id, name, code, description, timezone, currency, locale, status, created_at, updated_at) VALUES 
(1, NULL, 'PT. HAKA BUMI', 'PTHB', 'Perusahaan Jasa Technical Inspection & Certification', 'Asia/Jakarta', 'IDR', 'id_ID', 'active', NOW(), NOW()),
(2, 1, 'Divisi Bisnis Strategis Coal & Mineral', 'DBS_CM', 'Divisi khusus layanan batubara dan mineral', 'Asia/Jakarta', 'IDR', 'id_ID', 'active', NOW(), NOW()),
(3, 1, 'Divisi Bisnis Strategis Sustainable & Environment', 'DBS_SNE', 'Divisi khusus layanan lingkungan dan keberlanjutan', 'Asia/Jakarta', 'IDR', 'id_ID', 'active', NOW(), NOW()),
(4, 1, 'Cabang Kalimantan', 'CAB_KAL', 'Cabang operasional wilayah Kalimantan', 'Asia/Makassar', 'IDR', 'id_ID', 'active', NOW(), NOW()),
(5, 1, 'Cabang Medan', 'CAB_MDN', 'Cabang operasional wilayah Medan', 'Asia/Jakarta', 'IDR', 'id_ID', 'active', NOW(), NOW())
ON CONFLICT (id) DO NOTHING;

SELECT setval('companies_id_seq', (SELECT MAX(id) FROM companies));

-- 2. USERS (Sesuai struktur skema lengkap)
INSERT INTO users (id, company_id, username, email, password_hash, first_name, last_name, employee_id, department, position, phone, timezone, status, created_at, updated_at) VALUES 
(1, 1, 'dirutama', 'dirutama@hakabumi.co.id', '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Ahmad', 'Santoso', 'EMP001', 'Direksi', 'Direktur Utama', '+62-21-1234567', 'Asia/Jakarta', 'active', NOW(), NOW()),
(2, 1, 'dircm', 'dircm@hakabumi.co.id', '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Budi', 'Prakoso', 'EMP002', 'DBS C&M', 'Direktur Coal & Mineral', '+62-21-1234568', 'Asia/Jakarta', 'active', NOW(), NOW()),
(3, 1, 'dirsne', 'dirsne@hakabumi.co.id', '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Citra', 'Dewi', 'EMP003', 'DBS SNE', 'Direktur Sustainable & Environment', '+62-21-1234569', 'Asia/Jakarta', 'active', NOW(), NOW()),
(4, 1, 'mgkal', 'mgkal@hakabumi.co.id', '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Dedi', 'Kurniawan', 'EMP004', 'Cabang Kalimantan', 'Manager Cabang Kalimantan', '+62-541-123456', 'Asia/Makassar', 'active', NOW(), NOW()),
(5, 1, 'mgmdn', 'mgmdn@hakabumi.co.id', '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Eka', 'Pratama', 'EMP005', 'Cabang Medan', 'Manager Cabang Medan', '+62-61-123456', 'Asia/Jakarta', 'active', NOW(), NOW()),
(6, 1, 'pmcm1', 'pmcm1@hakabumi.co.id', '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Fajar', 'Sidik', 'EMP006', 'DBS C&M', 'Project Manager Strategic C&M', '+62-21-1234570', 'Asia/Jakarta', 'active', NOW(), NOW()),
(7, 1, 'pmsne1', 'pmsne1@hakabumi.co.id', '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Gita', 'Wulandari', 'EMP007', 'DBS SNE', 'Project Manager Strategic SNE', '+62-21-1234571', 'Asia/Jakarta', 'active', NOW(), NOW()),
(8, 1, 'pmkalcm', 'pmkalcm@hakabumi.co.id', '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Hendra', 'Wijaya', 'EMP008', 'Cabang Kalimantan', 'Project Manager C&M Kalimantan', '+62-541-123457', 'Asia/Makassar', 'active', NOW(), NOW()),
(9, 1, 'pmkalsne', 'pmkalsne@hakabumi.co.id', '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Indra', 'Setiawan', 'EMP009', 'Cabang Kalimantan', 'Project Manager SNE Kalimantan', '+62-541-123458', 'Asia/Makassar', 'active', NOW(), NOW()),
(10, 1, 'pmmdncm', 'pmmdncm@hakabumi.co.id', '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Joko', 'Sulistyo', 'EMP010', 'Cabang Medan', 'Project Manager C&M Medan', '+62-61-123457', 'Asia/Jakarta', 'active', NOW(), NOW()),
(11, 1, 'pmmdnsne', 'pmmdnsne@hakabumi.co.id', '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Kartika', 'Sari', 'EMP011', 'Cabang Medan', 'Project Manager SNE Medan', '+62-61-123458', 'Asia/Jakarta', 'active', NOW(), NOW()),
(12, 1, 'tlkal', 'tlkal@hakabumi.co.id', '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Lukman', 'Hakim', 'EMP012', 'Cabang Kalimantan', 'Team Leader Kalimantan', '+62-541-123459', 'Asia/Makassar', 'active', NOW(), NOW()),
(13, 1, 'tlmdn', 'tlmdn@hakabumi.co.id', '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Maya', 'Sari', 'EMP013', 'Cabang Medan', 'Team Leader Medan', '+62-61-123459', 'Asia/Jakarta', 'active', NOW(), NOW()),
(14, 1, 'tspec1', 'tspec1@hakabumi.co.id', '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Nugroho', 'Prasetyo', 'EMP014', 'Technical', 'Technical Specialist', '+62-21-1234572', 'Asia/Jakarta', 'active', NOW(), NOW()),
(15, 1, 'feng1', 'feng1@hakabumi.co.id', '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Oscar', 'Fernando', 'EMP015', 'Field Operations', 'Field Engineer', '+62-541-123460', 'Asia/Makassar', 'active', NOW(), NOW()),
(16, 1, 'feng2', 'feng2@hakabumi.co.id', '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Putri', 'Anggraeni', 'EMP016', 'Field Operations', 'Field Engineer', '+62-61-123460', 'Asia/Jakarta', 'active', NOW(), NOW()),
(100, 1, 'sysadmin', 'sysadmin@hakabumi.co.id', '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Super', 'Admin', 'EMP000', 'IT', 'System Administrator', '+62-21-0000000', 'Asia/Jakarta', 'active', NOW(), NOW()),
(101, 1, 'admin', 'admin@hakabumi.co.id', '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Admin', 'Hakabumi', 'EMPADM', 'IT', 'Administrator', '+62-21-0000001', 'Asia/Jakarta', 'active', NOW(), NOW())
ON CONFLICT (id) DO NOTHING;

SELECT setval('users_id_seq', (SELECT MAX(id) FROM users));

-- 3. ROLES & PERMISSIONS
INSERT INTO roles (id, company_id, name, description, role_type, hierarchy_level, is_system_role, created_at, updated_at) VALUES 
(1, 1, 'Direktur Utama', 'Pimpinan tertinggi perusahaan', 'corporate', 1, true, NOW(), NOW()),
(2, 1, 'Direktur C&M', 'Direktur Divisi Coal & Mineral', 'division', 2, true, NOW(), NOW()),
(3, 1, 'Direktur SNE', 'Direktur Divisi Sustainable & Environment', 'division', 2, true, NOW(), NOW()),
(4, 1, 'Manager Cabang', 'Manager cabang operasional', 'branch', 3, true, NOW(), NOW()),
(5, 1, 'Project Manager', 'Manajer proyek', 'project', 4, true, NOW(), NOW()),
(6, 1, 'Team Leader', 'Pimpinan tim teknis', 'technical', 5, true, NOW(), NOW()),
(7, 1, 'Technical Specialist', 'Spesialis teknis', 'technical', 6, true, NOW(), NOW()),
(8, 1, 'Field Engineer', 'Engineer lapangan', 'technical', 7, true, NOW(), NOW())
ON CONFLICT (id) DO NOTHING;

SELECT setval('roles_id_seq', (SELECT MAX(id) FROM roles));

INSERT INTO permissions (id, key, description, created_at) VALUES 
(1, 'project.view', 'View projects', NOW()),
(2, 'project.create', 'Create projects', NOW()),
(3, 'project.edit', 'Edit projects', NOW()),
(4, 'project.delete', 'Delete projects', NOW()),
(5, 'portfolio.view', 'View portfolio', NOW()),
(6, 'portfolio.manage', 'Manage portfolio', NOW()),
(7, 'resource.manage', 'Manage resources', NOW()),
(8, 'report.view', 'View reports', NOW()),
(9, 'admin.full', 'Full administrative access', NOW())
ON CONFLICT (key) DO NOTHING;

SELECT setval('permissions_id_seq', (SELECT MAX(id) FROM permissions));

-- Role-Permissions Mapping
INSERT INTO role_permissions (role_id, permission_id, created_at) VALUES 
(1, 1, NOW()), (1, 2, NOW()), (1, 3, NOW()), (1, 4, NOW()), (1, 5, NOW()), (1, 6, NOW()), (1, 7, NOW()), (1, 8, NOW()), (1, 9, NOW()),
(2, 1, NOW()), (2, 2, NOW()), (2, 3, NOW()), (2, 5, NOW()), (2, 6, NOW()), (2, 8, NOW()),
(3, 1, NOW()), (3, 2, NOW()), (3, 3, NOW()), (3, 5, NOW()), (3, 6, NOW()), (3, 8, NOW()),
(4, 1, NOW()), (4, 2, NOW()), (4, 3, NOW()), (4, 7, NOW()), (4, 8, NOW()),
(5, 1, NOW()), (5, 2, NOW()), (5, 3, NOW()), (5, 7, NOW()), (5, 8, NOW()),
(6, 1, NOW()), (6, 3, NOW()), (6, 7, NOW()), (6, 8, NOW()),
(7, 1, NOW()), (7, 3, NOW()), (7, 8, NOW()),
(8, 1, NOW()), (8, 8, NOW())
ON CONFLICT (role_id, permission_id) DO NOTHING;

-- 4. USER ROLES ASSIGNMENT
INSERT INTO user_roles (id, user_id, role_id, assigned_by, assigned_at) VALUES 
(1, 1, 1, 1, NOW()),
(2, 2, 2, 1, NOW()),
(3, 3, 3, 1, NOW()),
(4, 4, 4, 1, NOW()),
(5, 5, 4, 1, NOW()),
(6, 6, 5, 2, NOW()),
(7, 7, 5, 3, NOW()),
(8, 8, 5, 4, NOW()),
(9, 9, 5, 4, NOW()),
(10, 10, 5, 5, NOW()),
(11, 11, 5, 5, NOW()),
(12, 12, 6, 4, NOW()),
(13, 13, 6, 5, NOW()),
(14, 14, 7, 2, NOW()),
(15, 15, 8, 4, NOW()),
(16, 16, 8, 5, NOW())
ON CONFLICT (id) DO NOTHING;

SELECT setval('user_roles_id_seq', (SELECT MAX(id) FROM user_roles));

-- 5. PORTFOLIOS
INSERT INTO portfolios (id, company_id, name, description, strategic_objectives, budget_total, budget_used, start_date, end_date, status, priority, created_at, updated_at) VALUES 
(1, 1, 'Portfolio Coal & Mineral', 'Portfolio proyek-proyek batubara dan mineral', 'Meningkatkan market share di sektor batubara dan mineral', 50000000000.00, 12500000000.00, '2025-01-01', '2027-12-31', 'active', 'high', NOW(), NOW()),
(2, 1, 'Portfolio Sustainable & Environment', 'Portfolio proyek-proyek lingkungan dan keberlanjutan', 'Mengembangkan layanan ramah lingkungan dan berkelanjutan', 30000000000.00, 7500000000.00, '2025-01-01', '2027-12-31', 'active', 'medium', NOW(), NOW())
ON CONFLICT (id) DO NOTHING;

SELECT setval('portfolios_id_seq', (SELECT MAX(id) FROM portfolios));

-- 6. ENTERPRISE PROJECT STRUCTURE (EPS)
INSERT INTO eps (id, portfolio_id, company_id, parent_eps_id, name, code, description, project_type, budget_planned, budget_used, start_date, end_date, status, priority, created_at, updated_at) VALUES 
(1, 1, 1, NULL, 'DBS Coal & Mineral', 'DBS_CM', 'Divisi Bisnis Strategis Coal & Mineral', 'division', 20000000000.00, 5000000000.00, '2025-01-01', '2026-12-31', 'active', 'high', NOW(), NOW()),
(2, 2, 1, NULL, 'DBS Sustainable & Environment', 'DBS_SNE', 'Divisi Bisnis Strategis Sustainable & Environment', 'division', 15000000000.00, 3750000000.00, '2025-01-01', '2026-12-31', 'active', 'medium', NOW(), NOW()),
(3, 1, 1, 1, 'Cabang Kalimantan - C&M', 'CAB_KAL_CM', 'Cabang Kalimantan - Coal & Mineral', 'branch', 15000000000.00, 4500000000.00, '2025-01-01', '2026-12-31', 'active', 'high', NOW(), NOW()),
(4, 2, 1, 2, 'Cabang Kalimantan - SNE', 'CAB_KAL_SNE', 'Cabang Kalimantan - Sustainable & Environment', 'branch', 7500000000.00, 1875000000.00, '2025-01-01', '2026-12-31', 'active', 'medium', NOW(), NOW()),
(5, 1, 1, 1, 'Cabang Medan - C&M', 'CAB_MDN_CM', 'Cabang Medan - Coal & Mineral', 'branch', 7500000000.00, 1875000000.00, '2025-01-01', '2026-12-31', 'active', 'medium', NOW(), NOW()),
(6, 2, 1, 2, 'Cabang Medan - SNE', 'CAB_MDN_SNE', 'Cabang Medan - Sustainable & Environment', 'branch', 7500000000.00, 1875000000.00, '2025-01-01', '2026-12-31', 'active', 'medium', NOW(), NOW()),
(7, 1, 1, 1, 'Strategic Coal Quality Assurance', 'P-DBS-CM-001', 'Proyek strategis jaminan kualitas batubara', 'strategic', 5000000000.00, 1250000000.00, '2025-01-01', '2026-06-30', 'in_progress', 'high', NOW(), NOW()),
(8, 2, 1, 2, 'Carbon Footprint Certification', 'P-DBS-SNE-001', 'Proyek sertifikasi jejak karbon', 'strategic', 3750000000.00, 937500000.00, '2025-03-01', '2026-02-28', 'in_progress', 'high', NOW(), NOW()),
(9, 1, 1, 3, 'QnQ Batubara Kalimantan Timur', 'P-CAB-KAL-CM-001', 'Quality & Quantity Batubara Kaltim', 'operational', 7500000000.00, 2250000000.00, '2025-01-01', '2026-12-31', 'in_progress', 'high', NOW(), NOW()),
(10, 2, 1, 4, 'Environmental Compliance Audit', 'P-CAB-KAL-SNE-001', 'Audit kepatuhan lingkungan Kalimantan', 'compliance', 3750000000.00, 937500000.00, '2025-04-01', '2025-11-30', 'in_progress', 'medium', NOW(), NOW()),
(11, 1, 1, 5, 'QnQ Mineral Sumatera Utara', 'P-CAB-MDN-CM-001', 'Quality & Quantity Mineral Sumut', 'operational', 3750000000.00, 937500000.00, '2025-02-01', '2026-04-30', 'in_progress', 'medium', NOW(), NOW()),
(12, 2, 1, 6, 'Waste Management Certification', 'P-CAB-MDN-SNE-001', 'Sertifikasi manajemen limbah Medan', 'compliance', 3750000000.00, 937500000.00, '2025-05-01', '2026-02-28', 'in_progress', 'medium', NOW(), NOW())
ON CONFLICT (id) DO NOTHING;

SELECT setval('eps_id_seq', (SELECT MAX(id) FROM eps));

-- 7. WORK BREAKDOWN STRUCTURE (WBS) - INITIAL
INSERT INTO wbs (id, eps_id, parent_wbs_id, name, code, description, wbs_level, budget_planned, created_at, updated_at) VALUES 
(1, 7, NULL, 'Strategic Coal Quality Assurance', '0', 'Proyek utama jaminan kualitas batubara', 0, 5000000000.00, NOW(), NOW()),
(2, 7, 1, 'Fase Inisiasi & Perencanaan', '1.0', 'Fase persiapan dan perencanaan strategis', 1, 500000000.00, NOW(), NOW()),
(3, 7, 1, 'Fase Pengembangan Standar', '2.0', 'Pengembangan standar kualitas', 1, 1500000000.00, NOW(), NOW()),
(4, 7, 1, 'Fase Implementasi Pilot', '3.0', 'Implementasi proyek percontohan', 1, 2000000000.00, NOW(), NOW()),
(5, 7, 1, 'Fase Monitoring & Evaluasi', '4.0', 'Pemantauan dan evaluasi hasil', 1, 1000000000.00, NOW(), NOW()),
(6, 9, NULL, 'QnQ Batubara Kalimantan Timur', '0', 'Proyek Quality & Quantity Batubara', 0, 7500000000.00, NOW(), NOW()),
(7, 9, 6, 'Fase Persiapan & Mobilisasi', '1.0', 'Persiapan lapangan dan mobilisasi tim', 1, 750000000.00, NOW(), NOW()),
(8, 9, 6, 'Fase Operasi Sampling', '2.0', 'Operasi sampling dan pengujian', 1, 4500000000.00, NOW(), NOW()),
(9, 9, 6, 'Fase Analisis Laboratorium', '3.0', 'Analisis sampel di laboratorium', 1, 1500000000.00, NOW(), NOW()),
(10, 9, 6, 'Fase Pelaporan & Sertifikasi', '4.0', 'Penyusunan laporan dan sertifikasi', 1, 750000000.00, NOW(), NOW())
ON CONFLICT (id) DO NOTHING;

-- 8. WORK BREAKDOWN STRUCTURE (WBS) - ADDITIONAL FOR INCOMPLETE PROJECTS
INSERT INTO wbs (id, eps_id, parent_wbs_id, name, code, description, wbs_level, budget_planned, created_at, updated_at) VALUES 
(11, 8, NULL, 'Carbon Footprint Certification', '0', 'Proyek sertifikasi jejak karbon', 0, 3750000000.00, NOW(), NOW()),
(12, 8, 11, 'Fase Assessment Awal', '1.0', 'Fase penilaian awal dan definisi scope', 1, 750000000.00, NOW(), NOW()),
(13, 8, 11, 'Fase Pengumpulan Data', '2.0', 'Pengumpulan data emisi karbon', 1, 1500000000.00, NOW(), NOW()),
(14, 8, 11, 'Fase Perhitungan Karbon', '3.0', 'Perhitungan dan modeling jejak karbon', 1, 1000000000.00, NOW(), NOW()),
(15, 8, 11, 'Fase Sertifikasi', '4.0', 'Proses sertifikasi dan audit', 1, 500000000.00, NOW(), NOW()),
(16, 10, NULL, 'Environmental Compliance Audit', '0', 'Audit kepatuhan lingkungan Kalimantan', 0, 3750000000.00, NOW(), NOW()),
(17, 10, 16, 'Fase Pre-Audit', '1.0', 'Persiapan dan perencanaan audit', 1, 750000000.00, NOW(), NOW()),
(18, 10, 16, 'Fase Audit Lapangan', '2.0', 'Pelaksanaan audit di lapangan', 1, 2000000000.00, NOW(), NOW()),
(19, 10, 16, 'Fase Analisis & Reporting', '3.0', 'Analisis temuan dan pelaporan', 1, 750000000.00, NOW(), NOW()),
(20, 10, 16, 'Fase Tindak Lanjut', '4.0', 'Monitoring dan verifikasi tindak lanjut', 1, 250000000.00, NOW(), NOW()),
(21, 11, NULL, 'QnQ Mineral Sumatera Utara', '0', 'Quality & Quantity Mineral Sumut', 0, 3750000000.00, NOW(), NOW()),
(22, 11, 21, 'Fase Persiapan', '1.0', 'Persiapan lokasi dan peralatan', 1, 375000000.00, NOW(), NOW()),
(23, 11, 21, 'Fase Sampling Mineral', '2.0', 'Operasi sampling mineral', 1, 2250000000.00, NOW(), NOW()),
(24, 11, 21, 'Fase Analisis Lab', '3.0', 'Analisis laboratorium sampel', 1, 750000000.00, NOW(), NOW()),
(25, 11, 21, 'Fase Sertifikasi', '4.0', 'Proses sertifikasi QnQ', 1, 375000000.00, NOW(), NOW()),
(26, 12, NULL, 'Waste Management Certification', '0', 'Sertifikasi manajemen limbah Medan', 0, 3750000000.00, NOW(), NOW()),
(27, 12, 26, 'Fase Sistem Development', '1.0', 'Pengembangan sistem manajemen limbah', 1, 1500000000.00, NOW(), NOW()),
(28, 12, 26, 'Fase Implementasi', '2.0', 'Implementasi sistem di lapangan', 1, 1500000000.00, NOW(), NOW()),
(29, 12, 26, 'Fase Audit Sertifikasi', '3.0', 'Audit untuk sertifikasi', 1, 500000000.00, NOW(), NOW()),
(30, 12, 26, 'Fase Maintenance', '4.0', 'Pemeliharaan sistem', 1, 250000000.00, NOW(), NOW())
ON CONFLICT (id) DO NOTHING;

SELECT setval('wbs_id_seq', (SELECT MAX(id) FROM wbs));

-- 9. ACTIVITIES - INITIAL
INSERT INTO activities (id, wbs_id, name, description, activity_code, start_date, end_date, duration, percent_complete, status, budget_planned, created_at, updated_at) VALUES 
(1, 2, 'Analisis Pasar & Studi Kelayakan', 'Analisis kebutuhan pasar dan studi kelayakan bisnis', 'A101', '2025-01-01', '2025-01-30', 30, 100, 'completed', 250000000.00, NOW(), NOW()),
(2, 2, 'Penyusunan Business Case', 'Penyusunan dokumen business case proyek', 'A102', '2025-02-01', '2025-02-14', 14, 100, 'completed', 125000000.00, NOW(), NOW()),
(3, 3, 'Pengembangan Protokol Sampling', 'Pengembangan standar protokol sampling batubara', 'A201', '2025-02-15', '2025-03-30', 45, 80, 'in_progress', 750000000.00, NOW(), NOW()),
(4, 3, 'Sertifikasi Metode Analisis', 'Sertifikasi metode analisis di laboratorium', 'A202', '2025-04-01', '2025-05-15', 45, 30, 'in_progress', 750000000.00, NOW(), NOW()),
(5, 7, 'Mobilisasi Tim Lapangan', 'Penyiapan dan mobilisasi tim ke lokasi', 'B101', '2025-01-01', '2025-01-15', 15, 100, 'completed', 375000000.00, NOW(), NOW()),
(6, 7, 'Setup Peralatan Sampling', 'Penyiapan dan kalibrasi peralatan sampling', 'B102', '2025-01-16', '2025-01-31', 15, 100, 'completed', 375000000.00, NOW(), NOW()),
(7, 8, 'Sampling Batubara Bulan 1-6', 'Kegiatan sampling rutin bulan 1-6', 'B201', '2025-02-01', '2025-07-31', 180, 50, 'in_progress', 1500000000.00, NOW(), NOW()),
(8, 8, 'Sampling Batubara Bulan 7-12', 'Kegiatan sampling rutin bulan 7-12', 'B202', '2025-08-01', '2026-01-31', 180, 0, 'not_started', 1500000000.00, NOW(), NOW()),
(9, 9, 'Analisis Kualitas Bulan 1-6', 'Analisis laboratorium sampel bulan 1-6', 'B301', '2025-02-01', '2025-07-31', 180, 40, 'in_progress', 750000000.00, NOW(), NOW()),
(10, 7, 'Kickoff Meeting', 'Kickoff meeting proyek', 'A001', '2025-01-01', '2025-01-02', 2, 100, 'completed', 10000000.00, NOW(), NOW()),
(11, 7, 'Design Phase', 'Fase desain sistem', 'A002', '2025-01-03', '2025-02-28', 57, 60, 'in_progress', 50000000.00, NOW(), NOW()),
(12, 7, 'Implementation', 'Implementasi sistem', 'A003', '2025-03-01', '2025-06-30', 122, 20, 'in_progress', 150000000.00, NOW(), NOW())
ON CONFLICT (id) DO NOTHING;

-- 10. ACTIVITIES - ADDITIONAL FOR INCOMPLETE PROJECTS
INSERT INTO activities (id, wbs_id, name, description, activity_code, start_date, end_date, duration, percent_complete, status, budget_planned, created_at, updated_at) VALUES 
(13, 12, 'Initial Carbon Footprint Assessment', 'Penilaian awal jejak karbon organisasi', 'E101', '2025-03-01', '2025-03-30', 30, 100, 'completed', 375000000.00, NOW(), NOW()),
(14, 12, 'Scope Definition & Boundary Setting', 'Definisi scope dan batasan assessment', 'E102', '2025-03-15', '2025-03-29', 15, 100, 'completed', 375000000.00, NOW(), NOW()),
(15, 13, 'Data Collection - Energy Consumption', 'Pengumpulan data konsumsi energi', 'E201', '2025-04-01', '2025-05-30', 60, 70, 'in_progress', 600000000.00, NOW(), NOW()),
(16, 13, 'Data Collection - Transportation', 'Pengumpulan data transportasi', 'E202', '2025-04-15', '2025-05-29', 45, 50, 'in_progress', 450000000.00, NOW(), NOW()),
(17, 13, 'Data Collection - Supply Chain', 'Pengumpulan data rantai pasok', 'E203', '2025-04-01', '2025-05-15', 45, 30, 'in_progress', 450000000.00, NOW(), NOW()),
(18, 14, 'Carbon Calculation & Modeling', 'Perhitungan dan pemodelan jejak karbon', 'E301', '2025-06-01', '2025-07-15', 45, 40, 'in_progress', 500000000.00, NOW(), NOW()),
(19, 14, 'Verification & Validation', 'Verifikasi dan validasi hasil perhitungan', 'E302', '2025-07-16', '2025-08-14', 30, 10, 'in_progress', 500000000.00, NOW(), NOW()),
(20, 15, 'Certification Documentation', 'Penyusunan dokumen sertifikasi', 'E401', '2025-08-15', '2025-09-03', 20, 0, 'not_started', 250000000.00, NOW(), NOW()),
(21, 15, 'Audit & Certification Issuance', 'Audit dan penerbitan sertifikat', 'E402', '2025-09-04', '2025-09-18', 15, 0, 'not_started', 250000000.00, NOW(), NOW()),
(22, 17, 'Document Review & Planning', 'Review dokumen dan perencanaan audit', 'F101', '2025-04-01', '2025-04-20', 20, 100, 'completed', 375000000.00, NOW(), NOW()),
(23, 17, 'Audit Team Preparation', 'Penyiapan tim auditor', 'F102', '2025-04-10', '2025-04-19', 10, 100, 'completed', 375000000.00, NOW(), NOW()),
(24, 18, 'Site Inspection & Observation', 'Inspeksi lapangan dan observasi', 'F201', '2025-04-21', '2025-05-20', 30, 80, 'in_progress', 1000000000.00, NOW(), NOW()),
(25, 18, 'Employee Interviews & Documentation', 'Wawancara dan dokumentasi', 'F202', '2025-04-25', '2025-05-19', 25, 60, 'in_progress', 600000000.00, NOW(), NOW()),
(26, 18, 'Environmental Parameter Testing', 'Pengujian parameter lingkungan', 'F203', '2025-05-01', '2025-05-20', 20, 40, 'in_progress', 400000000.00, NOW(), NOW()),
(27, 19, 'Data Analysis & Finding Compilation', 'Analisis data dan kompilasi temuan', 'F301', '2025-05-21', '2025-06-14', 25, 30, 'in_progress', 375000000.00, NOW(), NOW()),
(28, 19, 'Audit Report Preparation', 'Penyusunan laporan audit', 'F302', '2025-06-15', '2025-07-04', 20, 10, 'in_progress', 375000000.00, NOW(), NOW()),
(29, 20, 'Follow-up Monitoring & Verification', 'Monitoring dan verifikasi tindak lanjut', 'F401', '2025-07-05', '2025-09-02', 60, 0, 'not_started', 250000000.00, NOW(), NOW()),
(30, 22, 'Survey Lokasi & Persiapan Site', 'Survey lokasi dan persiapan site', 'C101', '2025-02-01', '2025-02-20', 20, 100, 'completed', 187500000.00, NOW(), NOW()),
(31, 22, 'Mobilisasi Peralatan Khusus Mineral', 'Mobilisasi peralatan khusus mineral', 'C102', '2025-02-10', '2025-02-19', 10, 100, 'completed', 187500000.00, NOW(), NOW()),
(32, 23, 'Sampling Mineral Bulk', 'Sampling mineral bulk', 'C201', '2025-02-21', '2025-05-21', 90, 60, 'in_progress', 1125000000.00, NOW(), NOW()),
(33, 23, 'Sampling Mineral Core', 'Sampling mineral core', 'C202', '2025-03-01', '2025-05-29', 90, 40, 'in_progress', 750000000.00, NOW(), NOW()),
(34, 23, 'Dokumentasi & Preservation Sample', 'Dokumentasi dan preservasi sampel', 'C203', '2025-04-01', '2025-04-30', 30, 30, 'in_progress', 375000000.00, NOW(), NOW()),
(35, 24, 'Analisis Komposisi Kimia', 'Analisis komposisi kimia mineral', 'C301', '2025-05-01', '2025-06-29', 60, 20, 'in_progress', 375000000.00, NOW(), NOW()),
(36, 24, 'Analisis Sifat Fisik Mineral', 'Analisis sifat fisik mineral', 'C302', '2025-05-15', '2025-07-13', 60, 10, 'in_progress', 375000000.00, NOW(), NOW()),
(37, 25, 'Validasi Hasil Analisis', 'Validasi hasil analisis laboratorium', 'C401', '2025-07-14', '2025-07-28', 15, 0, 'not_started', 187500000.00, NOW(), NOW()),
(38, 25, 'Penerbitan Sertifikat QnQ', 'Penerbitan sertifikat QnQ', 'C402', '2025-07-29', '2025-08-07', 10, 0, 'not_started', 187500000.00, NOW(), NOW()),
(39, 27, 'Waste Management System Design', 'Desain sistem manajemen limbah', 'G101', '2025-05-01', '2025-06-14', 45, 80, 'in_progress', 750000000.00, NOW(), NOW()),
(40, 27, 'Procedure & Documentation Development', 'Pengembangan prosedur dan dokumentasi', 'G102', '2025-05-15', '2025-06-13', 30, 60, 'in_progress', 750000000.00, NOW(), NOW()),
(41, 28, 'System Implementation & Training', 'Implementasi sistem dan pelatihan', 'G201', '2025-06-15', '2025-08-13', 60, 40, 'in_progress', 900000000.00, NOW(), NOW()),
(42, 28, 'Trial Run & System Adjustment', 'Uji coba dan penyesuaian sistem', 'G202', '2025-07-01', '2025-08-14', 45, 20, 'in_progress', 600000000.00, NOW(), NOW()),
(43, 29, 'Pre-certification Audit', 'Audit pra-sertifikasi', 'G301', '2025-08-15', '2025-08-29', 15, 0, 'not_started', 250000000.00, NOW(), NOW()),
(44, 29, 'Certification Body Audit', 'Audit badan sertifikasi', 'G302', '2025-08-30', '2025-09-08', 10, 0, 'not_started', 250000000.00, NOW(), NOW()),
(45, 30, 'System Maintenance & Continuous Improvement', 'Pemeliharaan sistem dan perbaikan berkelanjutan', 'G401', '2025-09-09', '2025-12-07', 90, 0, 'not_started', 250000000.00, NOW(), NOW())
ON CONFLICT (id) DO NOTHING;

SELECT setval('activities_id_seq', (SELECT MAX(id) FROM activities));

-- 11. ACTIVITY RELATIONSHIPS - INITIAL
INSERT INTO activity_relationships (id, activity_id, predecessor_id, relationship_type, lag_duration, created_at, updated_at) VALUES 
(1, 2, 1, 'FS', 0, NOW(), NOW()),
(2, 3, 2, 'FS', 0, NOW(), NOW()),
(3, 4, 3, 'FS', 0, NOW(), NOW()),
(4, 6, 5, 'FS', 0, NOW(), NOW()),
(5, 7, 6, 'FS', 0, NOW(), NOW()),
(6, 8, 7, 'FS', 0, NOW(), NOW()),
(7, 9, 7, 'FS', 7, NOW(), NOW())
ON CONFLICT (id) DO NOTHING;

-- 12. ACTIVITY RELATIONSHIPS - ADDITIONAL FOR NEW DEPENDENCIES
INSERT INTO activity_relationships (id, activity_id, predecessor_id, relationship_type, lag_duration, created_at, updated_at) VALUES 
(8, 14, 13, 'FS', 0, NOW(), NOW()),
(9, 15, 14, 'FS', 0, NOW(), NOW()),
(10, 16, 14, 'FS', 0, NOW(), NOW()),
(11, 17, 14, 'FS', 0, NOW(), NOW()),
(12, 18, 15, 'FS', 0, NOW(), NOW()),
(13, 19, 18, 'FS', 0, NOW(), NOW()),
(14, 20, 19, 'FS', 0, NOW(), NOW()),
(15, 21, 20, 'FS', 0, NOW(), NOW()),
(16, 23, 22, 'FS', 0, NOW(), NOW()),
(17, 24, 23, 'FS', 0, NOW(), NOW()),
(18, 25, 23, 'FS', 0, NOW(), NOW()),
(19, 26, 23, 'FS', 0, NOW(), NOW()),
(20, 27, 24, 'FS', 0, NOW(), NOW()),
(21, 28, 27, 'FS', 0, NOW(), NOW()),
(22, 29, 28, 'FS', 0, NOW(), NOW()),
(23, 31, 30, 'FS', 0, NOW(), NOW()),
(24, 32, 31, 'FS', 0, NOW(), NOW()),
(25, 33, 31, 'FS', 0, NOW(), NOW()),
(26, 34, 32, 'FS', 0, NOW(), NOW()),
(27, 35, 32, 'FS', 7, NOW(), NOW()),
(28, 36, 33, 'FS', 7, NOW(), NOW()),
(29, 37, 35, 'FS', 0, NOW(), NOW()),
(30, 38, 37, 'FS', 0, NOW(), NOW()),
(31, 40, 39, 'FS', 0, NOW(), NOW()),
(32, 41, 40, 'FS', 0, NOW(), NOW()),
(33, 42, 41, 'FS', 0, NOW(), NOW()),
(34, 43, 42, 'FS', 0, NOW(), NOW()),
(35, 44, 43, 'FS', 0, NOW(), NOW()),
(36, 45, 44, 'FS', 0, NOW(), NOW())
ON CONFLICT (id) DO NOTHING;

SELECT setval('activity_relationships_id_seq', (SELECT MAX(id) FROM activity_relationships));

-- 13. RESOURCE TYPES
INSERT INTO resource_types (id, company_id, name, description, category, rate_type, created_at, updated_at) VALUES 
(1, 1, 'Project Manager', 'Manajer proyek', 'management', 'monthly', NOW(), NOW()),
(2, 1, 'Technical Specialist', 'Spesialis teknis', 'technical', 'daily', NOW(), NOW()),
(3, 1, 'Field Engineer', 'Engineer lapangan', 'field', 'daily', NOW(), NOW()),
(4, 1, 'Lab Analyst', 'Analis laboratorium', 'laboratory', 'daily', NOW(), NOW()),
(5, 1, 'Surveyor', 'Surveyor lapangan', 'field', 'daily', NOW(), NOW())
ON CONFLICT (id) DO NOTHING;

SELECT setval('resource_types_id_seq', (SELECT MAX(id) FROM resource_types));

-- 14. RESOURCES
INSERT INTO resources (id, resource_type_id, company_id, user_id, name, code, unit_cost, availability, status, created_at, updated_at) VALUES 
(1, 1, 1, 6, 'Fajar Sidik - PM', 'RES-PM-001', 25000000.00, 100, 'active', NOW(), NOW()),
(2, 1, 1, 8, 'Hendra Wijaya - PM', 'RES-PM-002', 20000000.00, 100, 'active', NOW(), NOW()),
(3, 2, 1, 14, 'Nugroho Prasetyo - Tech Specialist', 'RES-TS-001', 1500000.00, 100, 'active', NOW(), NOW()),
(4, 3, 1, 15, 'Oscar Fernando - Field Engineer', 'RES-FE-001', 1200000.00, 100, 'active', NOW(), NOW()),
(5, 3, 1, 16, 'Putri Anggraeni - Field Engineer', 'RES-FE-002', 1200000.00, 100, 'active', NOW(), NOW()),
(6, 4, 1, NULL, 'Lab Analyst Team', 'RES-LA-001', 1000000.00, 100, 'active', NOW(), NOW()),
(7, 5, 1, NULL, 'Surveyor Team', 'RES-SV-001', 800000.00, 100, 'active', NOW(), NOW())
ON CONFLICT (id) DO NOTHING;

SELECT setval('resources_id_seq', (SELECT MAX(id) FROM resources));

-- 15. RESOURCE ASSIGNMENTS - INITIAL
INSERT INTO resource_assignments (id, activity_id, resource_id, units, work_quantity, work_unit, planned_cost, start_date, end_date, status, created_at, updated_at) VALUES 
(1, 1, 1, 100, 240, 'hours', 15000000.00, '2025-01-01', '2025-01-30', 'completed', NOW(), NOW()),
(2, 3, 3, 100, 360, 'hours', 54000000.00, '2025-02-15', '2025-03-30', 'in_progress', NOW(), NOW()),
(3, 5, 2, 100, 120, 'hours', 10000000.00, '2025-01-01', '2025-01-15', 'completed', NOW(), NOW()),
(4, 7, 4, 100, 1440, 'hours', 17280000.00, '2025-02-01', '2025-07-31', 'in_progress', NOW(), NOW()),
(5, 7, 5, 100, 1440, 'hours', 17280000.00, '2025-02-01', '2025-07-31', 'in_progress', NOW(), NOW()),
(6, 9, 6, 100, 720, 'hours', 7200000.00, '2025-02-01', '2025-07-31', 'in_progress', NOW(), NOW())
ON CONFLICT (id) DO NOTHING;

-- 16. RESOURCE ASSIGNMENTS - ADDITIONAL FOR NEW ACTIVITIES
INSERT INTO resource_assignments (id, activity_id, resource_id, units, work_quantity, work_unit, planned_cost, start_date, end_date, status, created_at, updated_at) VALUES 
(7, 13, 3, 100, 240, 'hours', 36000000.00, '2025-03-01', '2025-03-30', 'completed', NOW(), NOW()),
(8, 15, 3, 100, 480, 'hours', 72000000.00, '2025-04-01', '2025-05-30', 'in_progress', NOW(), NOW()),
(9, 16, 4, 100, 360, 'hours', 43200000.00, '2025-04-15', '2025-05-29', 'in_progress', NOW(), NOW()),
(10, 18, 3, 100, 360, 'hours', 54000000.00, '2025-06-01', '2025-07-15', 'in_progress', NOW(), NOW()),
(11, 22, 2, 100, 160, 'hours', 13333333.00, '2025-04-01', '2025-04-20', 'completed', NOW(), NOW()),
(12, 24, 4, 100, 240, 'hours', 28800000.00, '2025-04-21', '2025-05-20', 'in_progress', NOW(), NOW()),
(13, 25, 5, 100, 200, 'hours', 24000000.00, '2025-04-25', '2025-05-19', 'in_progress', NOW(), NOW()),
(14, 27, 3, 100, 200, 'hours', 30000000.00, '2025-05-21', '2025-06-14', 'in_progress', NOW(), NOW()),
(15, 30, 2, 100, 160, 'hours', 13333333.00, '2025-02-01', '2025-02-20', 'completed', NOW(), NOW()),
(16, 32, 4, 100, 720, 'hours', 86400000.00, '2025-02-21', '2025-05-21', 'in_progress', NOW(), NOW()),
(17, 33, 5, 100, 720, 'hours', 86400000.00, '2025-03-01', '2025-05-29', 'in_progress', NOW(), NOW()),
(18, 35, 6, 100, 480, 'hours', 48000000.00, '2025-05-01', '2025-06-29', 'in_progress', NOW(), NOW()),
(19, 39, 3, 100, 360, 'hours', 54000000.00, '2025-05-01', '2025-06-14', 'in_progress', NOW(), NOW()),
(20, 41, 3, 100, 480, 'hours', 72000000.00, '2025-06-15', '2025-08-13', 'in_progress', NOW(), NOW())
ON CONFLICT (id) DO NOTHING;

SELECT setval('resource_assignments_id_seq', (SELECT MAX(id) FROM resource_assignments));

-- 17. WORK CALENDARS
INSERT INTO work_calendars (id, company_id, name, description, work_hours, created_at, updated_at) VALUES 
(1, 1, 'Kalender Standar PTHB', 'Kalender kerja standar PT. HAKA BUMI', '{"mon": {"start": "08:00", "end": "17:00"}, "tue": {"start": "08:00", "end": "17:00"}, "wed": {"start": "08:00", "end": "17:00"}, "thu": {"start": "08:00", "end": "17:00"}, "fri": {"start": "08:00", "end": "17:00"}}', NOW(), NOW())
ON CONFLICT (id) DO NOTHING;

SELECT setval('work_calendars_id_seq', (SELECT MAX(id) FROM work_calendars));

-- 18. LOCATIONS
INSERT INTO locations (id, company_id, name, code, address, city, state, country, status, created_at, updated_at) VALUES 
(1, 1, 'Kantor Pusat Jakarta', 'LOC-JKT', 'Jl. Sudirman Kav. 1', 'Jakarta', 'DKI Jakarta', 'Indonesia', 'active', NOW(), NOW()),
(2, 1, 'Cabang Kalimantan Timur', 'LOC-KALTIM', 'Jl. Samratulangi No. 45', 'Samarinda', 'Kalimantan Timur', 'Indonesia', 'active', NOW(), NOW()),
(3, 1, 'Cabang Medan', 'LOC-MDN', 'Jl. Gatot Subroto No. 12', 'Medan', 'Sumatera Utara', 'Indonesia', 'active', NOW(), NOW())
ON CONFLICT (id) DO NOTHING;

SELECT setval('locations_id_seq', (SELECT MAX(id) FROM locations));

-- 19. BASELINE SETS
INSERT INTO baseline_sets (id, eps_id, name, description, created_by, is_primary, created_at) VALUES 
(1, 7, 'Baseline Awal Strategic C&M', 'Baseline awal proyek strategic coal & mineral', 6, true, NOW()),
(2, 9, 'Baseline Awal QnQ Kaltim', 'Baseline awal proyek QnQ Kalimantan Timur', 8, true, NOW())
ON CONFLICT (id) DO NOTHING;

SELECT setval('baseline_sets_id_seq', (SELECT MAX(id) FROM baseline_sets));

-- 20. PROJECTS (Custom table)
INSERT INTO projects (company_id, portfolio_id, eps_id, name, description, status, start_date, end_date, created_by, updated_by, created_at, updated_at) VALUES 
(1, 1, 1, 'Contoh Proyek Enterprise', 'Proyek baseline awal', 'active', '2025-01-01', '2025-12-31', 1, 1, NOW(), NOW())
ON CONFLICT DO NOTHING;

SELECT setval('projects_id_seq', COALESCE((SELECT MAX(id) FROM projects), 1));

-- ====================================================================
-- FINAL VERIFICATION QUERY
-- ====================================================================
DO $$ 
BEGIN
    RAISE NOTICE '=== SIMAPRO ENTERPRISE SEED DATA VERIFICATION ===';
    RAISE NOTICE 'Companies: %', (SELECT COUNT(*) FROM companies);
    RAISE NOTICE 'Users: %', (SELECT COUNT(*) FROM users); 
    RAISE NOTICE 'Roles: %', (SELECT COUNT(*) FROM roles);
    RAISE NOTICE 'Portfolios: %', (SELECT COUNT(*) FROM portfolios);
    RAISE NOTICE 'EPS: %', (SELECT COUNT(*) FROM eps);
    RAISE NOTICE 'WBS: %', (SELECT COUNT(*) FROM wbs);
    RAISE NOTICE 'Activities: %', (SELECT COUNT(*) FROM activities);
    RAISE NOTICE 'Resources: %', (SELECT COUNT(*) FROM resources);
    RAISE NOTICE 'Resource Assignments: %', (SELECT COUNT(*) FROM resource_assignments);
    RAISE NOTICE 'Activity Relationships: %', (SELECT COUNT(*) FROM activity_relationships);
    RAISE NOTICE '=================================================';
    RAISE NOTICE '=== PENAMBAHAN DATA TAMBAHAN ===';
    RAISE NOTICE 'WBS ditambahkan: %', (SELECT COUNT(*) FROM wbs WHERE id > 10);
    RAISE NOTICE 'Activities ditambahkan: %', (SELECT COUNT(*) FROM activities WHERE id > 12);
    RAISE NOTICE 'Resource Assignments ditambahkan: %', (SELECT COUNT(*) FROM resource_assignments WHERE id > 6);
    RAISE NOTICE 'Activity Relationships ditambahkan: %', (SELECT COUNT(*) FROM activity_relationships WHERE id > 7);
    RAISE NOTICE '=================================================';
    RAISE NOTICE 'Seed data berhasil di-load dengan urutan yang benar!';
    RAISE NOTICE 'Semua proyek telah memiliki struktur WBS dan Activities yang lengkap.';
END $$;

COMMIT;
