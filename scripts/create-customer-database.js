#!/usr/bin/env node

/**
 * 🏥 TẠO DATABASE SETUP CHO KHÁCH HÀNG MỚI
 * 
 * Script tổng hợp để tạo file setup database cho khách hàng mới.
 * Tự động chọn phương pháp tốt nhất (Supabase CLI hoặc migration files).
 * 
 * Usage:
 *   node scripts/create-customer-database.js
 *   # Hoặc với tham số:
 *   node scripts/create-customer-database.js "Bệnh viện ABC"
 */

const fs = require('fs');
const path = require('path');
const readline = require('readline');
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

// Check if Supabase CLI is available
function checkSupabaseCLI() {
  try {
    execSync('supabase --version', { stdio: 'pipe' });
    return true;
  } catch (error) {
    return false;
  }
}

// Check if user is logged in to Supabase
function checkSupabaseLogin() {
  try {
    execSync('supabase projects list', { stdio: 'pipe' });
    return true;
  } catch (error) {
    return false;
  }
}

// Generate safe filename from customer name
function generateFilename(customerName) {
  const safeName = customerName
    .toLowerCase()
    .replace(/[^a-z0-9\s]/g, '') // Remove special characters
    .replace(/\s+/g, '-') // Replace spaces with hyphens
    .replace(/^-+|-+$/g, ''); // Remove leading/trailing hyphens
  
  return `setup-${safeName}.sql`;
}

// Validate customer name
function validateCustomerName(name) {
  if (!name || name.length < 3) {
    return 'Tên khách hàng phải có ít nhất 3 ký tự';
  }
  if (name.length > 100) {
    return 'Tên khách hàng không được quá 100 ký tự';
  }
  return null;
}

// Run export using Supabase CLI
function runSupabaseExport(customerName, filename) {
  try {
    log('🚀 Sử dụng Supabase CLI để export schema...');
    
    // Run the export script
    execSync(`node scripts/export-supabase-schema.js --customer="${customerName}" --output="${filename}"`, {
      stdio: 'inherit'
    });
    
    return true;
  } catch (error) {
    logError(`Lỗi khi export bằng Supabase CLI: ${error.message}`);
    return false;
  }
}

// Run export using migration files
function runMigrationExport(customerName, filename) {
  try {
    log('📄 Sử dụng migration files để tạo schema...');
    
    // Run the package script
    execSync(`node scripts/package-database-schema.js --customer="${customerName}" --output="${filename}"`, {
      stdio: 'inherit'
    });
    
    return true;
  } catch (error) {
    logError(`Lỗi khi tạo schema từ migration files: ${error.message}`);
    return false;
  }
}

// Main function
async function createCustomerDatabase() {
  log(`${colors.blue}${colors.bright}🏥 TẠO DATABASE SETUP CHO KHÁCH HÀNG MỚI${colors.reset}\n`);
  
  try {
    // Step 1: Get customer name
    let customerName = process.argv[2];
    
    if (!customerName) {
      log('Vui lòng nhập thông tin khách hàng:\n');
      
      while (true) {
        customerName = await askQuestion('📝 Tên khách hàng (VD: Bệnh viện Đa khoa ABC): ');
        
        const validation = validateCustomerName(customerName);
        if (validation) {
          logError(validation);
          continue;
        }
        break;
      }
    }
    
    // Step 2: Generate filename
    const filename = generateFilename(customerName);
    
    // Step 3: Check available methods
    log('\n🔍 Kiểm tra phương pháp export có sẵn...');
    
    const hasSupabaseCLI = checkSupabaseCLI();
    const isLoggedIn = hasSupabaseCLI ? checkSupabaseLogin() : false;
    
    if (hasSupabaseCLI) {
      logSuccess('Supabase CLI đã được cài đặt');
      if (isLoggedIn) {
        logSuccess('Đã đăng nhập Supabase');
      } else {
        logWarning('Chưa đăng nhập Supabase');
      }
    } else {
      logWarning('Supabase CLI chưa được cài đặt');
    }
    
    // Step 4: Choose method
    let useSupabaseCLI = false;
    
    if (hasSupabaseCLI && isLoggedIn) {
      log('\n📋 Thông tin setup:');
      log(`   Khách hàng: ${colors.green}${customerName}${colors.reset}`);
      log(`   File output: ${colors.green}${filename}${colors.reset}`);
      log(`   Phương pháp: ${colors.green}Supabase CLI (Khuyến nghị)${colors.reset}`);
      
      const confirm = await askQuestion('\n❓ Sử dụng Supabase CLI để export? (Y/n): ');
      useSupabaseCLI = confirm.toLowerCase() !== 'n' && confirm.toLowerCase() !== 'no';
    } else {
      log('\n📋 Thông tin setup:');
      log(`   Khách hàng: ${colors.green}${customerName}${colors.reset}`);
      log(`   File output: ${colors.green}${filename}${colors.reset}`);
      log(`   Phương pháp: ${colors.yellow}Migration files (Fallback)${colors.reset}`);
      
      if (!hasSupabaseCLI) {
        logInfo('💡 Để có kết quả chính xác hơn, hãy cài đặt Supabase CLI:');
        logInfo('   node scripts/setup-supabase-cli.js');
      } else if (!isLoggedIn) {
        logInfo('💡 Để sử dụng Supabase CLI, hãy đăng nhập:');
        logInfo('   supabase login');
      }
      
      const confirm = await askQuestion('\n❓ Tiếp tục với migration files? (y/N): ');
      if (confirm.toLowerCase() !== 'y' && confirm.toLowerCase() !== 'yes') {
        log('\n❌ Đã hủy tạo file setup.');
        rl.close();
        return;
      }
    }
    
    // Close readline before running scripts
    rl.close();
    
    // Step 5: Run export
    log(`\n🚀 Bắt đầu tạo file setup...\n`);
    
    let success = false;
    
    if (useSupabaseCLI) {
      success = runSupabaseExport(customerName, filename);
      
      // Fallback to migration files if Supabase CLI fails
      if (!success) {
        logWarning('Supabase CLI thất bại, chuyển sang sử dụng migration files...');
        success = runMigrationExport(customerName, filename);
      }
    } else {
      success = runMigrationExport(customerName, filename);
    }
    
    // Step 6: Show results
    if (success) {
      log(`\n${colors.green}${colors.bright}🎉 HOÀN TẤT TẠO FILE SETUP${colors.reset}`);
      log(`\n📁 File đã được tạo: ${colors.green}${filename}${colors.reset}`);
      
      // Check file size
      if (fs.existsSync(filename)) {
        const stats = fs.statSync(filename);
        log(`📊 Kích thước file: ${Math.round(stats.size / 1024)} KB`);
      }
      
      log(`\n🔄 Các bước tiếp theo:`);
      log(`   1. Gửi file ${filename} cho khách hàng`);
      log(`   2. Hướng dẫn khách hàng tạo project Supabase mới`);
      log(`   3. Chạy file SQL trong Supabase SQL Editor`);
      log(`   4. Cập nhật .env.local với thông tin Supabase mới`);
      log(`   5. Test đăng nhập và các chức năng cơ bản`);
      
      log(`\n⚠️  Lưu ý quan trọng:`);
      log(`   - Đổi mật khẩu mặc định ngay sau khi setup`);
      log(`   - Backup database định kỳ`);
      log(`   - Không chia sẻ thông tin kết nối database`);
      
    } else {
      logError('Không thể tạo file setup. Vui lòng kiểm tra lại cấu hình.');
      process.exit(1);
    }
    
  } catch (error) {
    logError(`Lỗi khi tạo database setup: ${error.message}`);
    rl.close();
    process.exit(1);
  }
}

// Handle process termination
process.on('SIGINT', () => {
  log('\n\n❌ Đã hủy tạo file setup.');
  rl.close();
  process.exit(0);
});

// Run the script
if (require.main === module) {
  createCustomerDatabase();
}

module.exports = { createCustomerDatabase };
