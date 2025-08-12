#!/usr/bin/env node

/**
 * 🛠️ SETUP SUPABASE CLI
 * 
 * Script này giúp setup và cấu hình Supabase CLI để export schema
 * 
 * Usage:
 *   node scripts/setup-supabase-cli.js
 */

const { execSync } = require('child_process');
const fs = require('fs');
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

// Check if command exists
function commandExists(command) {
  try {
    execSync(`${command} --version`, { stdio: 'pipe' });
    return true;
  } catch (error) {
    return false;
  }
}

// Check if Supabase CLI is installed
function checkSupabaseCLI() {
  return commandExists('supabase');
}

// Install Supabase CLI
function installSupabaseCLI() {
  log('Đang cài đặt Supabase CLI...');
  
  try {
    if (process.platform === 'win32') {
      // Windows
      if (commandExists('npm')) {
        execSync('npm install -g supabase', { stdio: 'inherit' });
      } else if (commandExists('winget')) {
        execSync('winget install --id Supabase.CLI', { stdio: 'inherit' });
      } else {
        throw new Error('Không tìm thấy npm hoặc winget để cài đặt');
      }
    } else if (process.platform === 'darwin') {
      // macOS
      if (commandExists('brew')) {
        execSync('brew install supabase/tap/supabase', { stdio: 'inherit' });
      } else if (commandExists('npm')) {
        execSync('npm install -g supabase', { stdio: 'inherit' });
      } else {
        throw new Error('Không tìm thấy brew hoặc npm để cài đặt');
      }
    } else {
      // Linux
      if (commandExists('npm')) {
        execSync('npm install -g supabase', { stdio: 'inherit' });
      } else {
        throw new Error('Vui lòng cài đặt npm trước khi tiếp tục');
      }
    }
    
    logSuccess('Đã cài đặt Supabase CLI thành công');
    return true;
  } catch (error) {
    logError(`Lỗi khi cài đặt Supabase CLI: ${error.message}`);
    return false;
  }
}

// Login to Supabase
async function loginSupabase() {
  log('Đang đăng nhập Supabase...');
  
  try {
    execSync('supabase login', { stdio: 'inherit' });
    logSuccess('Đã đăng nhập Supabase thành công');
    return true;
  } catch (error) {
    logError(`Lỗi khi đăng nhập: ${error.message}`);
    return false;
  }
}

// List Supabase projects
function listProjects() {
  try {
    const output = execSync('supabase projects list', { encoding: 'utf8' });
    log('\n📋 Danh sách projects:');
    log(output);
    return true;
  } catch (error) {
    logError(`Lỗi khi lấy danh sách projects: ${error.message}`);
    return false;
  }
}

// Link to project
async function linkProject() {
  try {
    const projectRef = await askQuestion('\n📝 Nhập Project Reference ID: ');
    
    if (!projectRef) {
      logWarning('Bỏ qua việc link project');
      return false;
    }
    
    execSync(`supabase link --project-ref ${projectRef}`, { stdio: 'inherit' });
    logSuccess('Đã link project thành công');
    return true;
  } catch (error) {
    logError(`Lỗi khi link project: ${error.message}`);
    return false;
  }
}

// Check environment files
function checkEnvFiles() {
  const envFiles = ['.env.local', '.env'];
  let foundEnv = false;
  
  log('\n🔍 Kiểm tra file môi trường:');
  
  for (const envFile of envFiles) {
    if (fs.existsSync(envFile)) {
      logSuccess(`Tìm thấy ${envFile}`);
      foundEnv = true;
      
      // Check for Supabase variables
      const content = fs.readFileSync(envFile, 'utf8');
      if (content.includes('NEXT_PUBLIC_SUPABASE_URL')) {
        logSuccess('  - NEXT_PUBLIC_SUPABASE_URL ✓');
      } else {
        logWarning('  - NEXT_PUBLIC_SUPABASE_URL ✗');
      }
      
      if (content.includes('NEXT_PUBLIC_SUPABASE_ANON_KEY')) {
        logSuccess('  - NEXT_PUBLIC_SUPABASE_ANON_KEY ✓');
      } else {
        logWarning('  - NEXT_PUBLIC_SUPABASE_ANON_KEY ✗');
      }
    }
  }
  
  if (!foundEnv) {
    logWarning('Không tìm thấy file .env.local hoặc .env');
    logInfo('Bạn có thể tạo file .env.local với thông tin Supabase');
  }
  
  return foundEnv;
}

// Test connection
function testConnection() {
  try {
    log('\n🔗 Kiểm tra kết nối...');
    execSync('supabase status', { stdio: 'inherit' });
    logSuccess('Kết nối Supabase hoạt động tốt');
    return true;
  } catch (error) {
    logWarning('Không thể kiểm tra status (có thể do chưa link project)');
    return false;
  }
}

// Main setup function
async function setupSupabaseCLI() {
  log(`${colors.blue}${colors.bright}🛠️  SETUP SUPABASE CLI${colors.reset}\n`);
  
  try {
    // Step 1: Check if CLI is installed
    log('🔍 Kiểm tra Supabase CLI...');
    if (checkSupabaseCLI()) {
      logSuccess('Supabase CLI đã được cài đặt');
    } else {
      logWarning('Supabase CLI chưa được cài đặt');
      
      const install = await askQuestion('Bạn có muốn cài đặt Supabase CLI không? (y/N): ');
      if (install.toLowerCase() === 'y' || install.toLowerCase() === 'yes') {
        if (!installSupabaseCLI()) {
          throw new Error('Không thể cài đặt Supabase CLI');
        }
      } else {
        log('Vui lòng cài đặt Supabase CLI thủ công:');
        log('  npm install -g supabase');
        log('  hoặc xem hướng dẫn tại: https://supabase.com/docs/guides/cli');
        rl.close();
        return;
      }
    }
    
    // Step 2: Login
    log('\n🔐 Kiểm tra đăng nhập...');
    try {
      execSync('supabase projects list', { stdio: 'pipe' });
      logSuccess('Đã đăng nhập Supabase');
    } catch (error) {
      logWarning('Chưa đăng nhập Supabase');
      
      const login = await askQuestion('Bạn có muốn đăng nhập ngay bây giờ không? (y/N): ');
      if (login.toLowerCase() === 'y' || login.toLowerCase() === 'yes') {
        if (!await loginSupabase()) {
          throw new Error('Không thể đăng nhập Supabase');
        }
      }
    }
    
    // Step 3: List projects
    log('\n📋 Lấy danh sách projects...');
    listProjects();
    
    // Step 4: Link project
    const link = await askQuestion('\nBạn có muốn link với project cụ thể không? (y/N): ');
    if (link.toLowerCase() === 'y' || link.toLowerCase() === 'yes') {
      await linkProject();
    }
    
    // Step 5: Check environment
    checkEnvFiles();
    
    // Step 6: Test connection
    testConnection();
    
    // Summary
    log(`\n${colors.green}${colors.bright}🎉 SETUP HOÀN TẤT${colors.reset}`);
    log(`\n✅ Supabase CLI đã sẵn sàng sử dụng!`);
    log(`\n🚀 Bước tiếp theo:`);
    log(`  1. Chạy: node scripts/export-supabase-schema.js --customer="Tên khách hàng"`);
    log(`  2. Hoặc: node scripts/export-supabase-schema.js --customer="Bệnh viện ABC" --output="setup-abc.sql"`);
    
  } catch (error) {
    logError(`Setup thất bại: ${error.message}`);
  } finally {
    rl.close();
  }
}

// Handle process termination
process.on('SIGINT', () => {
  log('\n\n❌ Đã hủy setup.');
  rl.close();
  process.exit(0);
});

// Run the setup
if (require.main === module) {
  setupSupabaseCLI();
}

module.exports = { setupSupabaseCLI };
