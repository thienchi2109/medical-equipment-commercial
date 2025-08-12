#!/usr/bin/env node

/**
 * 🏥 TẠO SETUP DATABASE CHO KHÁCH HÀNG MỚI
 * 
 * Script tiện ích để tạo nhanh file setup database cho khách hàng mới.
 * Tự động tạo tên file phù hợp và cung cấp hướng dẫn chi tiết.
 * 
 * Usage:
 *   node scripts/create-customer-setup.js
 *   # Hoặc với tham số:
 *   node scripts/create-customer-setup.js "Bệnh viện Đa khoa XYZ"
 */

const fs = require('fs');
const path = require('path');
const readline = require('readline');
const { packageDatabaseSchema } = require('./package-database-schema');

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

// Main interactive function
async function createCustomerSetup() {
  log(`${colors.blue}${colors.bright}🏥 TẠO SETUP DATABASE CHO KHÁCH HÀNG MỚI${colors.reset}\n`);
  
  try {
    let customerName = process.argv[2];
    
    // If no customer name provided, ask for it
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
    
    // Generate filename
    const filename = generateFilename(customerName);
    
    // Show summary and confirm
    log(`\n📋 Thông tin setup:`);
    log(`   Khách hàng: ${colors.green}${customerName}${colors.reset}`);
    log(`   File output: ${colors.green}${filename}${colors.reset}`);
    
    const confirm = await askQuestion('\n❓ Tiếp tục tạo file setup? (y/N): ');
    
    if (confirm.toLowerCase() !== 'y' && confirm.toLowerCase() !== 'yes') {
      log('\n❌ Đã hủy tạo file setup.');
      rl.close();
      return;
    }
    
    // Close readline before running the main script
    rl.close();
    
    log(`\n🚀 Bắt đầu tạo file setup...\n`);
    
    // Set process arguments for the main script
    process.argv = ['node', 'package-database-schema.js', `--customer=${customerName}`, `--output=${filename}`];
    
    // Run the main packaging function
    await packageDatabaseSchema();
    
    // Show final instructions
    log(`\n${colors.green}${colors.bright}🎉 HOÀN TẤT TẠO FILE SETUP${colors.reset}`);
    log(`\n📁 File đã được tạo: ${colors.green}${filename}${colors.reset}`);
    
    log(`\n🔄 Các bước tiếp theo:`);
    log(`   1. Gửi file ${filename} cho khách hàng`);
    log(`   2. Hướng dẫn khách hàng tạo project Supabase mới`);
    log(`   3. Chạy file SQL trong Supabase SQL Editor`);
    log(`   4. Cập nhật .env.local với thông tin Supabase mới`);
    log(`   5. Test đăng nhập với tài khoản admin/admin123`);
    
    log(`\n📋 Tài khoản mặc định:`);
    log(`   - admin / admin123 (Quản trị viên)`);
    log(`   - to_qltb / qltb123 (Trưởng tổ QLTB)`);
    log(`   - qltb_noi / qltb123 (QLTB Khoa Nội)`);
    log(`   - user_demo / user123 (Nhân viên demo)`);
    
    log(`\n⚠️  Lưu ý quan trọng:`);
    log(`   - Đổi mật khẩu mặc định ngay sau khi setup`);
    log(`   - Backup database định kỳ`);
    log(`   - Không chia sẻ thông tin kết nối database`);
    
  } catch (error) {
    logError(`Lỗi khi tạo file setup: ${error.message}`);
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
  createCustomerSetup();
}

module.exports = { createCustomerSetup, generateFilename, validateCustomerName };
