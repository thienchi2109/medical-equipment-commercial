#!/usr/bin/env node

/**
 * 🔧 FIX REALTIME CONNECTION ISSUES
 * 
 * Script này giúp chẩn đoán và khắc phục các vấn đề kết nối Realtime
 * với Supabase project mới.
 * 
 * Usage:
 *   node scripts/fix-realtime-connection.js
 */

const fs = require('fs');
const path = require('path');
const readline = require('readline');

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

function logWarning(message) {
  log(`⚠️  ${message}`, colors.yellow);
}

function logInfo(message) {
  log(`ℹ️  ${message}`, colors.blue);
}

// Create readline interface
const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

// Prompt user for input
function askQuestion(question) {
  return new Promise((resolve) => {
    rl.question(question, (answer) => {
      resolve(answer.trim());
    });
  });
}

// Check .env.local file
function checkEnvFile() {
  const envPath = '.env.local';
  
  if (!fs.existsSync(envPath)) {
    logError('File .env.local không tồn tại');
    return null;
  }
  
  const content = fs.readFileSync(envPath, 'utf8');
  const lines = content.split('\n');
  const env = {};
  
  for (const line of lines) {
    const trimmed = line.trim();
    if (trimmed && !trimmed.startsWith('#')) {
      const [key, ...valueParts] = trimmed.split('=');
      if (key && valueParts.length > 0) {
        env[key.trim()] = valueParts.join('=').trim();
      }
    }
  }
  
  return env;
}

// Validate Supabase configuration
function validateSupabaseConfig(env) {
  const issues = [];
  
  // Check required variables
  if (!env.NEXT_PUBLIC_SUPABASE_URL) {
    issues.push('Thiếu NEXT_PUBLIC_SUPABASE_URL');
  } else if (!env.NEXT_PUBLIC_SUPABASE_URL.includes('supabase.co')) {
    issues.push('NEXT_PUBLIC_SUPABASE_URL không hợp lệ');
  }
  
  if (!env.NEXT_PUBLIC_SUPABASE_ANON_KEY) {
    issues.push('Thiếu NEXT_PUBLIC_SUPABASE_ANON_KEY');
  } else if (!env.NEXT_PUBLIC_SUPABASE_ANON_KEY.startsWith('eyJ')) {
    issues.push('NEXT_PUBLIC_SUPABASE_ANON_KEY không hợp lệ (phải là JWT token)');
  }
  
  if (!env.SUPABASE_SERVICE_ROLE_KEY) {
    issues.push('Thiếu SUPABASE_SERVICE_ROLE_KEY (cần cho Realtime)');
  } else if (!env.SUPABASE_SERVICE_ROLE_KEY.startsWith('eyJ')) {
    issues.push('SUPABASE_SERVICE_ROLE_KEY không hợp lệ (phải là JWT token)');
  }
  
  // Check for problematic configurations
  if (env.REALTIME_ENDPOINT && env.REALTIME_ENDPOINT.includes('localhost')) {
    issues.push('REALTIME_ENDPOINT đang trỏ về localhost (nên xóa hoặc comment)');
  }
  
  return issues;
}

// Generate SQL to check Realtime status
function generateRealtimeCheckSQL() {
  return `
-- Kiểm tra Realtime Publications
SELECT 
    'REALTIME STATUS' as check_type,
    COUNT(*) as enabled_tables,
    CASE 
        WHEN COUNT(*) >= 6 THEN '✅ GOOD - Realtime enabled'
        WHEN COUNT(*) > 0 THEN '⚠️ PARTIAL - Some tables missing'
        ELSE '❌ FAILED - No tables enabled'
    END as status
FROM pg_publication_tables 
WHERE pubname = 'supabase_realtime'
AND tablename IN (
    'thiet_bi', 'nhan_vien', 'nhat_ky_su_dung', 
    'lich_su_thiet_bi', 'yeu_cau_luan_chuyen', 'ke_hoach_bao_tri'
);

-- Liệt kê các bảng đã enable Realtime
SELECT 
    'ENABLED TABLES' as info,
    tablename as table_name,
    '✅ Realtime enabled' as status
FROM pg_publication_tables 
WHERE pubname = 'supabase_realtime'
ORDER BY tablename;

-- Kiểm tra permissions cho anon role
SELECT 
    'PERMISSIONS CHECK' as check_type,
    schemaname,
    tablename,
    privilege_type,
    grantee
FROM information_schema.table_privileges 
WHERE grantee = 'anon' 
AND schemaname = 'public'
AND tablename IN ('thiet_bi', 'nhan_vien', 'nhat_ky_su_dung')
ORDER BY tablename, privilege_type;
`;
}

// Generate SQL to fix Realtime
function generateRealtimeFixSQL() {
  return `
-- Enable Realtime Publications cho các bảng chính
ALTER PUBLICATION supabase_realtime ADD TABLE IF NOT EXISTS thiet_bi;
ALTER PUBLICATION supabase_realtime ADD TABLE IF NOT EXISTS nhan_vien;
ALTER PUBLICATION supabase_realtime ADD TABLE IF NOT EXISTS nhat_ky_su_dung;
ALTER PUBLICATION supabase_realtime ADD TABLE IF NOT EXISTS lich_su_thiet_bi;
ALTER PUBLICATION supabase_realtime ADD TABLE IF NOT EXISTS yeu_cau_luan_chuyen;
ALTER PUBLICATION supabase_realtime ADD TABLE IF NOT EXISTS lich_su_luan_chuyen;
ALTER PUBLICATION supabase_realtime ADD TABLE IF NOT EXISTS ke_hoach_bao_tri;
ALTER PUBLICATION supabase_realtime ADD TABLE IF NOT EXISTS cong_viec_bao_tri;
ALTER PUBLICATION supabase_realtime ADD TABLE IF NOT EXISTS yeu_cau_sua_chua;

-- Grant permissions cho anon role (cho custom auth)
GRANT USAGE ON SCHEMA realtime TO anon;
GRANT SELECT ON realtime.messages TO anon;

-- Grant permissions cho các bảng chính
GRANT ALL ON thiet_bi TO anon;
GRANT ALL ON nhan_vien TO anon; 
GRANT ALL ON nhat_ky_su_dung TO anon;
GRANT ALL ON lich_su_thiet_bi TO anon;
GRANT ALL ON yeu_cau_luan_chuyen TO anon;
GRANT ALL ON lich_su_luan_chuyen TO anon;
GRANT ALL ON ke_hoach_bao_tri TO anon;
GRANT ALL ON cong_viec_bao_tri TO anon;
GRANT ALL ON yeu_cau_sua_chua TO anon;

-- Grant sequence permissions
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO anon;

-- Verify kết quả
SELECT 'Realtime fix completed!' as result;
`;
}

// Main function
async function fixRealtimeConnection() {
  log(`${colors.blue}${colors.bright}🔧 KHẮC PHỤC VẤN ĐỀ REALTIME CONNECTION${colors.reset}\n`);
  
  try {
    // Step 1: Check .env.local
    log('🔍 Bước 1: Kiểm tra cấu hình .env.local');
    const env = checkEnvFile();
    
    if (!env) {
      logError('Không thể đọc file .env.local');
      rl.close();
      return;
    }
    
    logSuccess('Đã đọc file .env.local');
    
    // Step 2: Validate configuration
    log('\n🔍 Bước 2: Kiểm tra cấu hình Supabase');
    const issues = validateSupabaseConfig(env);
    
    if (issues.length === 0) {
      logSuccess('Cấu hình .env.local hợp lệ');
    } else {
      logWarning('Phát hiện các vấn đề:');
      issues.forEach(issue => log(`  - ${issue}`, colors.yellow));
      
      const fix = await askQuestion('\n❓ Bạn có muốn tôi hướng dẫn sửa các vấn đề này không? (y/N): ');
      if (fix.toLowerCase() === 'y' || fix.toLowerCase() === 'yes') {
        await fixEnvIssues(env, issues);
      }
    }
    
    // Step 3: Generate SQL scripts
    log('\n📝 Bước 3: Tạo SQL scripts để kiểm tra và sửa Realtime');
    
    // Write check script
    const checkSQL = generateRealtimeCheckSQL();
    fs.writeFileSync('check-realtime.sql', checkSQL);
    logSuccess('Đã tạo file check-realtime.sql');
    
    // Write fix script
    const fixSQL = generateRealtimeFixSQL();
    fs.writeFileSync('fix-realtime.sql', fixSQL);
    logSuccess('Đã tạo file fix-realtime.sql');
    
    // Step 4: Instructions
    log(`\n${colors.green}${colors.bright}🎯 HƯỚNG DẪN KHẮC PHỤC${colors.reset}`);
    
    log('\n1️⃣ Kiểm tra Realtime status:');
    log('   - Vào Supabase Dashboard > SQL Editor');
    log('   - Copy nội dung file check-realtime.sql và chạy');
    log('   - Xem kết quả để biết Realtime có hoạt động không');
    
    log('\n2️⃣ Nếu Realtime chưa hoạt động:');
    log('   - Copy nội dung file fix-realtime.sql và chạy');
    log('   - Chạy lại check-realtime.sql để verify');
    
    log('\n3️⃣ Cập nhật Service Role Key:');
    log('   - Vào Supabase Dashboard > Settings > API');
    log('   - Copy service_role key');
    log('   - Thêm vào .env.local: SUPABASE_SERVICE_ROLE_KEY=your_key_here');
    
    log('\n4️⃣ Restart ứng dụng:');
    log('   - Dừng server (Ctrl+C)');
    log('   - Chạy lại: npm run dev');
    log('   - Kiểm tra console không còn lỗi Realtime');
    
    log(`\n${colors.cyan}💡 Lưu ý:${colors.reset}`);
    log('   - Realtime cần Service Role Key để hoạt động');
    log('   - Đảm bảo không có REALTIME_ENDPOINT trỏ về localhost');
    log('   - Nếu vẫn lỗi, kiểm tra Network tab trong DevTools');
    
  } catch (error) {
    logError(`Lỗi: ${error.message}`);
  } finally {
    rl.close();
  }
}

// Fix environment issues
async function fixEnvIssues(env, issues) {
  log('\n🔧 Hướng dẫn sửa từng vấn đề:');
  
  for (const issue of issues) {
    log(`\n❌ ${issue}`);
    
    if (issue.includes('SUPABASE_SERVICE_ROLE_KEY')) {
      log('💡 Cách sửa:');
      log('   1. Vào Supabase Dashboard > Settings > API');
      log('   2. Copy "service_role" key (không phải anon key)');
      log('   3. Thêm vào .env.local:');
      log('      SUPABASE_SERVICE_ROLE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...');
    }
    
    if (issue.includes('REALTIME_ENDPOINT')) {
      log('💡 Cách sửa:');
      log('   1. Mở file .env.local');
      log('   2. Comment hoặc xóa dòng REALTIME_ENDPOINT');
      log('   3. Supabase sẽ tự động sử dụng Realtime endpoint');
    }
    
    if (issue.includes('NEXT_PUBLIC_SUPABASE_URL')) {
      log('💡 Cách sửa:');
      log('   1. Vào Supabase Dashboard > Settings > API');
      log('   2. Copy "Project URL"');
      log('   3. Cập nhật NEXT_PUBLIC_SUPABASE_URL trong .env.local');
    }
    
    if (issue.includes('NEXT_PUBLIC_SUPABASE_ANON_KEY')) {
      log('💡 Cách sửa:');
      log('   1. Vào Supabase Dashboard > Settings > API');
      log('   2. Copy "anon public" key');
      log('   3. Cập nhật NEXT_PUBLIC_SUPABASE_ANON_KEY trong .env.local');
    }
  }
}

// Handle process termination
process.on('SIGINT', () => {
  log('\n\n❌ Đã hủy.');
  rl.close();
  process.exit(0);
});

// Run the script
if (require.main === module) {
  fixRealtimeConnection();
}

module.exports = { fixRealtimeConnection };
