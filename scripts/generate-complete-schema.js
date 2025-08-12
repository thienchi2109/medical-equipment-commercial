#!/usr/bin/env node

/**
 * 📄 GENERATE COMPLETE DATABASE SCHEMA
 * 
 * This script combines all migration files into a single comprehensive schema file
 * that can be used to setup a new customer database from scratch.
 */

const fs = require('fs');
const path = require('path');

// Color utilities
const colors = {
  reset: '\x1b[0m',
  bright: '\x1b[1m',
  red: '\x1b[31m',
  green: '\x1b[32m',
  yellow: '\x1b[33m',
  blue: '\x1b[34m',
  cyan: '\x1b[36m'
};

function log(message, color = colors.reset) {
  console.log(`${color}${message}${colors.reset}`);
}

function logSuccess(message) {
  log(`✅ ${message}`, colors.green);
}

function logError(message) {
  log(`❌ ${message}`, colors.red);
}

// Get all migration files in order
function getMigrationFiles() {
  const migrationsDir = path.join(__dirname, '../supabase/migrations');
  
  if (!fs.existsSync(migrationsDir)) {
    throw new Error('Migrations directory not found');
  }
  
  const files = fs.readdirSync(migrationsDir)
    .filter(file => file.endsWith('.sql'))
    .sort(); // Files are timestamped, so sorting works
  
  return files.map(file => ({
    name: file,
    path: path.join(migrationsDir, file)
  }));
}

// Clean and process SQL content
function processSQLContent(content, fileName) {
  // Remove comments that are just separators
  content = content.replace(/^-- =+.*$/gm, '');
  
  // Remove excessive blank lines
  content = content.replace(/\n\s*\n\s*\n/g, '\n\n');
  
  // Add file header
  const header = `\n-- =====================================================\n-- ${fileName}\n-- =====================================================\n`;
  
  return header + content.trim() + '\n';
}

// Generate sample data based on customer info
function generateCustomerSampleData(customerName = 'Demo Hospital') {
  const customerCode = customerName.replace(/\s+/g, '_').toUpperCase();
  
  return `
-- =====================================================
-- SAMPLE DATA FOR ${customerName}
-- =====================================================

-- Insert sample departments (phong_ban)
INSERT INTO phong_ban (ten_phong_ban, mo_ta) VALUES
('Khoa Nội', 'Khoa Nội tổng hợp'),
('Khoa Ngoại', 'Khoa Ngoại tổng hợp'),
('Khoa Sản', 'Khoa Sản phụ khoa'),
('Khoa Nhi', 'Khoa Nhi'),
('Phòng Xét nghiệm', 'Phòng Xét nghiệm'),
('Phòng Chẩn đoán hình ảnh', 'Phòng CĐHA'),
('Khoa Cấp cứu', 'Khoa Cấp cứu'),
('Phòng Phẫu thuật', 'Phòng Phẫu thuật')
ON CONFLICT (ten_phong_ban) DO NOTHING;

-- Insert sample equipment types (loai_thiet_bi)
INSERT INTO loai_thiet_bi (ten_loai, mo_ta) VALUES
('Thiết bị y tế', 'Thiết bị y tế chung'),
('Máy xét nghiệm', 'Máy xét nghiệm'),
('Máy chẩn đoán', 'Máy chẩn đoán hình ảnh'),
('Thiết bị phẫu thuật', 'Thiết bị phẫu thuật'),
('Thiết bị hồi sức', 'Thiết bị hồi sức cấp cứu'),
('Thiết bị theo dõi', 'Thiết bị theo dõi bệnh nhân')
ON CONFLICT (ten_loai) DO NOTHING;

-- Insert sample users (nhan_vien)
INSERT INTO nhan_vien (username, password, full_name, role, khoa_phong) VALUES
('admin', 'admin123', 'Quản trị viên ${customerName}', 'admin', NULL),
('qltb_noi', 'qltb123', 'QLTB Khoa Nội', 'qltb_khoa', 'Khoa Nội'),
('qltb_ngoai', 'qltb123', 'QLTB Khoa Ngoại', 'qltb_khoa', 'Khoa Ngoại'),
('qltb_san', 'qltb123', 'QLTB Khoa Sản', 'qltb_khoa', 'Khoa Sản'),
('user_xn', 'user123', 'Nhân viên XN', 'user', 'Phòng Xét nghiệm'),
('user_cdha', 'user123', 'Nhân viên CĐHA', 'user', 'Phòng Chẩn đoán hình ảnh')
ON CONFLICT (username) DO NOTHING;

-- Insert sample equipment (thiet_bi)
INSERT INTO thiet_bi (
  ma_thiet_bi, ten_thiet_bi, model, hang_san_xuat, nam_san_xuat,
  khoa_phong_quan_ly, vi_tri_lap_dat, tinh_trang, ngay_nhap, gia_tri
) VALUES
('${customerCode}_001', 'Máy siêu âm tim', 'Vivid E95', 'GE Healthcare', 2022, 'Khoa Nội', 'Phòng khám tim mạch', 'Đang sử dụng', CURRENT_DATE - INTERVAL '1 year', 2500000000),
('${customerCode}_002', 'Máy X-quang kỹ thuật số', 'Ysio Max', 'Siemens', 2021, 'Phòng Chẩn đoán hình ảnh', 'Phòng X-quang 1', 'Đang sử dụng', CURRENT_DATE - INTERVAL '2 years', 3500000000),
('${customerCode}_003', 'Máy xét nghiệm máu tự động', 'DxH 900', 'Beckman Coulter', 2023, 'Phòng Xét nghiệm', 'Khu vực huyết học', 'Đang sử dụng', CURRENT_DATE - INTERVAL '6 months', 1800000000),
('${customerCode}_004', 'Máy thở', 'Servo-i', 'Maquet', 2020, 'Khoa Cấp cứu', 'Phòng hồi sức', 'Đang sử dụng', CURRENT_DATE - INTERVAL '3 years', 800000000),
('${customerCode}_005', 'Máy monitor theo dõi', 'IntelliVue MX800', 'Philips', 2022, 'Khoa Nội', 'Phòng theo dõi', 'Đang sử dụng', CURRENT_DATE - INTERVAL '1 year', 150000000)
ON CONFLICT (ma_thiet_bi) DO NOTHING;

-- Insert sample maintenance plans (ke_hoach_bao_tri)
INSERT INTO ke_hoach_bao_tri (
  thiet_bi_id, loai_bao_tri, mo_ta, ngay_bat_dau, ngay_ket_thuc, 
  chu_ky_lap_lai, trang_thai, nguoi_phu_trach_id
) VALUES
((SELECT id FROM thiet_bi WHERE ma_thiet_bi = '${customerCode}_001'), 'Bảo trì định kỳ', 'Bảo trì máy siêu âm 6 tháng/lần', CURRENT_DATE + INTERVAL '1 month', CURRENT_DATE + INTERVAL '1 month', 6, 'da_lap_lich', (SELECT id FROM nhan_vien WHERE username = 'qltb_noi')),
((SELECT id FROM thiet_bi WHERE ma_thiet_bi = '${customerCode}_002'), 'Hiệu chuẩn', 'Hiệu chuẩn máy X-quang hàng năm', CURRENT_DATE + INTERVAL '2 months', CURRENT_DATE + INTERVAL '2 months', 12, 'da_lap_lich', (SELECT id FROM nhan_vien WHERE username = 'user_cdha')),
((SELECT id FROM thiet_bi WHERE ma_thiet_bi = '${customerCode}_003'), 'Bảo trì định kỳ', 'Bảo trì máy xét nghiệm 3 tháng/lần', CURRENT_DATE + INTERVAL '15 days', CURRENT_DATE + INTERVAL '15 days', 3, 'da_lap_lich', (SELECT id FROM nhan_vien WHERE username = 'user_xn'))
ON CONFLICT DO NOTHING;

-- Update statistics for better query performance
ANALYZE thiet_bi;
ANALYZE nhan_vien;
ANALYZE phong_ban;
ANALYZE loai_thiet_bi;
ANALYZE ke_hoach_bao_tri;

-- Success message
SELECT 'Sample data inserted successfully for ${customerName}' as status;
`;
}

// Main function to generate complete schema
function generateCompleteSchema() {
  log(`${colors.blue}${colors.bright}📄 GENERATING COMPLETE DATABASE SCHEMA${colors.reset}\n`);
  
  try {
    // Get all migration files
    const migrationFiles = getMigrationFiles();
    log(`Found ${migrationFiles.length} migration files`);
    
    // Start building the complete schema
    let completeSchema = `-- =====================================================
-- COMPLETE DATABASE SCHEMA FOR MEDICAL EQUIPMENT MANAGEMENT
-- Generated automatically from all migration files
-- Generated on: ${new Date().toISOString()}
-- =====================================================

-- Enable required extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Set timezone
SET timezone = 'Asia/Ho_Chi_Minh';

`;

    // Process each migration file
    for (const file of migrationFiles) {
      log(`Processing: ${file.name}`);
      
      try {
        const content = fs.readFileSync(file.path, 'utf8');
        const processedContent = processSQLContent(content, file.name);
        completeSchema += processedContent + '\n';
      } catch (error) {
        logError(`Failed to process ${file.name}: ${error.message}`);
      }
    }
    
    // Add sample data
    completeSchema += generateCustomerSampleData();
    
    // Add final success message
    completeSchema += `
-- =====================================================
-- SCHEMA GENERATION COMPLETE
-- =====================================================

-- Final verification
SELECT 
  'Schema setup completed successfully!' as status,
  COUNT(*) as total_tables
FROM information_schema.tables 
WHERE table_schema = 'public' 
  AND table_type = 'BASE TABLE';

-- Show created tables
SELECT 
  table_name,
  CASE 
    WHEN table_name LIKE '%thiet_bi%' THEN 'Equipment'
    WHEN table_name LIKE '%nhan_vien%' THEN 'Users'
    WHEN table_name LIKE '%bao_tri%' THEN 'Maintenance'
    WHEN table_name LIKE '%sua_chua%' THEN 'Repairs'
    WHEN table_name LIKE '%luan_chuyen%' THEN 'Transfers'
    ELSE 'Other'
  END as category
FROM information_schema.tables 
WHERE table_schema = 'public' 
  AND table_type = 'BASE TABLE'
ORDER BY category, table_name;
`;

    // Write the complete schema file
    const outputPath = path.join(__dirname, '../database/complete-schema.sql');
    
    // Ensure database directory exists
    const dbDir = path.dirname(outputPath);
    if (!fs.existsSync(dbDir)) {
      fs.mkdirSync(dbDir, { recursive: true });
    }
    
    fs.writeFileSync(outputPath, completeSchema);
    
    logSuccess(`Complete schema generated: ${outputPath}`);
    log(`\n📊 Schema Statistics:`);
    log(`  - Migration files processed: ${migrationFiles.length}`);
    log(`  - Total schema size: ${Math.round(completeSchema.length / 1024)} KB`);
    log(`  - Output file: database/complete-schema.sql`);
    
    log(`\n🚀 Usage:`);
    log(`  psql -d your_database -f database/complete-schema.sql`);
    log(`  # Or use with Supabase CLI:`);
    log(`  supabase db reset --db-url "your-supabase-url"`);
    
  } catch (error) {
    logError(`Schema generation failed: ${error.message}`);
    process.exit(1);
  }
}

// Run the generator
if (require.main === module) {
  generateCompleteSchema();
}

module.exports = { generateCompleteSchema, generateCustomerSampleData };
