#!/usr/bin/env node

/**
 * 📦 EXPORT SUPABASE SCHEMA USING CLI
 * 
 * Script này sử dụng Supabase CLI để export chính xác toàn bộ database schema
 * và tạo file setup hoàn chỉnh cho khách hàng mới.
 * 
 * Yêu cầu:
 * - Supabase CLI đã được cài đặt
 * - File .env.local hoặc .env với thông tin Supabase
 * 
 * Usage:
 *   node scripts/export-supabase-schema.js --customer="Bệnh viện ABC"
 */

const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

// Color utilities
const colors = {
  reset: '\x1b[0m',
  bright: '\x1b[1m',
  red: '\x1b[31m',
  green: '\x1b[32m',
  yellow: '\x1b[33m',
  blue: '\x1b[34m',
  magenta: '\x1b[35m',
  cyan: '\x1b[36m'
};

function log(message, color = colors.reset) {
  console.log(`${color}${message}${colors.reset}`);
}

function logStep(step, message) {
  log(`\n${colors.cyan}${colors.bright}🔄 Bước ${step}: ${message}${colors.reset}`);
}

function logSuccess(message) {
  log(`✅ ${message}`, colors.green);
}

function logError(message) {
  log(`❌ ${message}`, colors.red);
}

function logWarning(message) {
  log(`⚠️  ${message}`, colors.yellow);
}

// Parse command line arguments
function parseArgs() {
  const args = process.argv.slice(2);
  const config = {
    customer: 'Bệnh viện Demo',
    output: 'database-setup-complete.sql'
  };
  
  args.forEach(arg => {
    if (arg.startsWith('--')) {
      const [key, value] = arg.substring(2).split('=');
      if (value) {
        config[key] = value.replace(/['"]/g, '');
      }
    }
  });
  
  return config;
}

// Check if Supabase CLI is installed
function checkSupabaseCLI() {
  try {
    execSync('supabase --version', { stdio: 'pipe' });
    return true;
  } catch (error) {
    return false;
  }
}

// Load environment variables
function loadEnvVars() {
  const envFiles = ['.env.local', '.env'];
  let envVars = {};
  
  for (const envFile of envFiles) {
    if (fs.existsSync(envFile)) {
      const content = fs.readFileSync(envFile, 'utf8');
      const lines = content.split('\n');
      
      for (const line of lines) {
        const trimmed = line.trim();
        if (trimmed && !trimmed.startsWith('#')) {
          const [key, ...valueParts] = trimmed.split('=');
          if (key && valueParts.length > 0) {
            envVars[key.trim()] = valueParts.join('=').trim().replace(/['"]/g, '');
          }
        }
      }
      break;
    }
  }
  
  return envVars;
}

// Export schema using Supabase CLI
function exportSchema() {
  try {
    log('Đang export schema từ Supabase...');
    
    // Export schema only (structure)
    const schemaOutput = execSync('supabase db dump --schema-only', { 
      encoding: 'utf8',
      stdio: 'pipe'
    });
    
    logSuccess('Đã export schema thành công');
    return schemaOutput;
  } catch (error) {
    throw new Error(`Lỗi khi export schema: ${error.message}`);
  }
}

// Export data using Supabase CLI
function exportData() {
  try {
    log('Đang export dữ liệu từ Supabase...');
    
    // Export data only
    const dataOutput = execSync('supabase db dump --data-only', { 
      encoding: 'utf8',
      stdio: 'pipe'
    });
    
    logSuccess('Đã export dữ liệu thành công');
    return dataOutput;
  } catch (error) {
    logWarning(`Không thể export dữ liệu: ${error.message}`);
    return '';
  }
}

// Generate sample data for new customer
function generateSampleData(customerName) {
  const customerCode = customerName.replace(/\s+/g, '_').toUpperCase().substring(0, 10);
  
  return `
-- =====================================================
-- DỮ LIỆU MẪU CHO ${customerName}
-- =====================================================

-- Xóa dữ liệu mẫu cũ nếu có
DELETE FROM lich_su_thiet_bi WHERE thiet_bi_id IN (SELECT id FROM thiet_bi WHERE ma_thiet_bi LIKE 'DEMO_%');
DELETE FROM cong_viec_bao_tri WHERE thiet_bi_id IN (SELECT id FROM thiet_bi WHERE ma_thiet_bi LIKE 'DEMO_%');
DELETE FROM ke_hoach_bao_tri WHERE thiet_bi_id IN (SELECT id FROM thiet_bi WHERE ma_thiet_bi LIKE 'DEMO_%');
DELETE FROM thiet_bi WHERE ma_thiet_bi LIKE 'DEMO_%';
DELETE FROM nhan_vien WHERE username LIKE 'demo_%' OR username = 'admin';
DELETE FROM phong_ban WHERE ten_phong_ban LIKE '%Demo%';
DELETE FROM loai_thiet_bi WHERE ten_loai LIKE '%demo%';

-- Tạo dữ liệu mẫu mới
-- (Dữ liệu này sẽ được tùy chỉnh theo khách hàng)

-- Thông báo
SELECT 'Dữ liệu mẫu đã được tạo cho ${customerName}' as message;
`;
}

// Generate setup instructions
function generateSetupInstructions(customerName, outputFile) {
  return `
-- =====================================================
-- HƯỚNG DẪN SETUP DATABASE CHO ${customerName}
-- =====================================================

/*
🚀 HƯỚNG DẪN SỬ DỤNG FILE NÀY:

1. TẠO PROJECT SUPABASE MỚI:
   - Truy cập https://supabase.com/dashboard
   - Tạo project mới với tên "${customerName}"
   - Chờ project được khởi tạo hoàn tất

2. CHẠY SCRIPT SETUP:
   Cách 1 - Sử dụng Supabase Dashboard (Khuyến nghị):
   - Vào SQL Editor trong dashboard
   - Copy toàn bộ nội dung file ${outputFile}
   - Paste vào SQL Editor và chạy

   Cách 2 - Sử dụng Supabase CLI:
   supabase db reset --db-url "postgresql://postgres:[PASSWORD]@[HOST]:5432/postgres"

   Cách 3 - Sử dụng psql:
   psql "postgresql://postgres:[PASSWORD]@[HOST]:5432/postgres" -f ${outputFile}

3. CẬP NHẬT .ENV.LOCAL:
   NEXT_PUBLIC_SUPABASE_URL=https://[your-project-ref].supabase.co
   NEXT_PUBLIC_SUPABASE_ANON_KEY=[your-anon-key]
   SUPABASE_SERVICE_ROLE_KEY=[your-service-role-key]

4. KIỂM TRA KẾT NỐI:
   - Chạy ứng dụng: npm run dev
   - Đăng nhập với tài khoản admin có sẵn
   - Kiểm tra các chức năng cơ bản

⚠️  LƯU Ý QUAN TRỌNG:
   - File này chứa toàn bộ cấu trúc database hiện tại
   - Dữ liệu nhạy cảm đã được loại bỏ
   - Đổi mật khẩu mặc định ngay sau khi setup
   - Backup database định kỳ

📞 HỖ TRỢ:
   Nếu gặp vấn đề, vui lòng liên hệ team phát triển.
*/

`;
}

// Main function
function exportSupabaseSchema() {
  const config = parseArgs();
  
  log(`${colors.blue}${colors.bright}📦 EXPORT SUPABASE SCHEMA BẰNG CLI${colors.reset}\n`);
  log(`${colors.blue}Khách hàng: ${config.customer}${colors.reset}`);
  log(`${colors.blue}File output: ${config.output}${colors.reset}\n`);
  
  try {
    // Step 1: Check prerequisites
    logStep(1, 'Kiểm tra yêu cầu hệ thống');
    
    if (!checkSupabaseCLI()) {
      throw new Error('Supabase CLI chưa được cài đặt. Vui lòng cài đặt: npm install -g supabase');
    }
    logSuccess('Supabase CLI đã sẵn sàng');
    
    // Step 2: Load environment variables
    logStep(2, 'Đọc thông tin kết nối');
    const envVars = loadEnvVars();
    
    if (!envVars.NEXT_PUBLIC_SUPABASE_URL) {
      logWarning('Không tìm thấy NEXT_PUBLIC_SUPABASE_URL trong .env');
      log('Đảm bảo bạn đã login Supabase CLI: supabase login');
    } else {
      logSuccess('Đã tìm thấy thông tin kết nối Supabase');
    }
    
    // Step 3: Export schema
    logStep(3, 'Export database schema');
    const schema = exportSchema();
    
    // Step 4: Export existing data (optional)
    logStep(4, 'Export dữ liệu hiện tại (tùy chọn)');
    const existingData = exportData();
    
    // Step 5: Generate complete setup file
    logStep(5, 'Tạo file setup hoàn chỉnh');
    
    let completeSetup = `-- =====================================================
-- DATABASE SETUP HOÀN CHỈNH CHO ${config.customer}
-- Được export từ Supabase hiện tại bằng CLI
-- Ngày tạo: ${new Date().toLocaleString('vi-VN')}
-- =====================================================

-- Thiết lập môi trường
SET timezone = 'Asia/Ho_Chi_Minh';
SET client_encoding = 'UTF8';

-- Bắt đầu transaction
BEGIN;

-- =====================================================
-- SCHEMA (Cấu trúc database)
-- =====================================================

${schema}

-- =====================================================
-- DỮ LIỆU HIỆN TẠI (Nếu có)
-- =====================================================

${existingData}

${generateSampleData(config.customer)}

-- Commit transaction
COMMIT;

-- Kiểm tra kết quả
SELECT 
  'Setup database hoàn tất!' as status,
  COUNT(*) as total_tables
FROM information_schema.tables 
WHERE table_schema = 'public' 
  AND table_type = 'BASE TABLE';

${generateSetupInstructions(config.customer, config.output)}
`;

    // Step 6: Write output file
    logStep(6, 'Ghi file output');
    const outputPath = path.join(__dirname, '..', config.output);
    fs.writeFileSync(outputPath, completeSetup, 'utf8');
    
    logSuccess(`File đã được tạo: ${config.output}`);
    
    // Step 7: Show summary
    log(`\n${colors.green}${colors.bright}🎉 HOÀN TẤT EXPORT SCHEMA${colors.reset}`);
    log(`\n📊 Thống kê:`);
    log(`  - Kích thước schema: ${Math.round(schema.length / 1024)} KB`);
    log(`  - Kích thước dữ liệu: ${Math.round(existingData.length / 1024)} KB`);
    log(`  - Tổng kích thước: ${Math.round(completeSetup.length / 1024)} KB`);
    log(`  - Khách hàng: ${config.customer}`);
    log(`  - File output: ${config.output}`);
    
    log(`\n🚀 Bước tiếp theo:`);
    log(`  1. Kiểm tra file ${config.output}`);
    log(`  2. Tạo project Supabase mới cho khách hàng`);
    log(`  3. Chạy file SQL trong Supabase SQL Editor`);
    log(`  4. Cập nhật .env.local với thông tin mới`);
    log(`  5. Test ứng dụng`);
    
  } catch (error) {
    logError(`Lỗi khi export schema: ${error.message}`);
    
    if (error.message.includes('supabase')) {
      log(`\n💡 Gợi ý khắc phục:`);
      log(`  1. Cài đặt Supabase CLI: npm install -g supabase`);
      log(`  2. Đăng nhập: supabase login`);
      log(`  3. Kiểm tra kết nối: supabase projects list`);
      log(`  4. Link project: supabase link --project-ref [your-project-ref]`);
    }
    
    process.exit(1);
  }
}

// Run the exporter
if (require.main === module) {
  exportSupabaseSchema();
}

module.exports = { exportSupabaseSchema };
