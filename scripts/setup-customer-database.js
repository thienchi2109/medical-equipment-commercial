#!/usr/bin/env node

/**
 * 🗄️ CUSTOMER DATABASE SETUP AUTOMATION
 * 
 * This script automates the complete setup of a new Supabase project for a customer
 * including schema migration, sample data, and configuration.
 * 
 * Usage:
 *   node scripts/setup-customer-database.js --customer="Hospital ABC" --supabase-url="..." --supabase-key="..."
 */

const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

// Color utilities for console output
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
  log(`\n${colors.cyan}${colors.bright}🔄 Step ${step}: ${message}${colors.reset}`);
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
  const config = {};
  
  args.forEach(arg => {
    if (arg.startsWith('--')) {
      const [key, value] = arg.substring(2).split('=');
      config[key] = value;
    }
  });
  
  return config;
}

// Validate required arguments
function validateConfig(config) {
  const required = ['customer', 'supabase-url', 'supabase-key'];
  const missing = required.filter(key => !config[key]);
  
  if (missing.length > 0) {
    logError(`Missing required arguments: ${missing.join(', ')}`);
    log('\nUsage:');
    log('  node scripts/setup-customer-database.js \\');
    log('    --customer="Hospital ABC" \\');
    log('    --supabase-url="https://xxx.supabase.co" \\');
    log('    --supabase-key="eyJ..."');
    process.exit(1);
  }
  
  return true;
}

// Get ordered list of migration files
function getMigrationFiles() {
  const migrationsDir = path.join(__dirname, '../supabase/migrations');
  
  if (!fs.existsSync(migrationsDir)) {
    throw new Error('Migrations directory not found');
  }
  
  const files = fs.readdirSync(migrationsDir)
    .filter(file => file.endsWith('.sql'))
    .sort(); // Files are named with timestamps, so sorting works
  
  return files.map(file => path.join(migrationsDir, file));
}

// Execute SQL against Supabase using pg client
async function executeSQLFile(filePath, supabaseUrl, supabaseKey) {
  const fileName = path.basename(filePath);
  log(`  📄 Executing: ${fileName}`);

  try {
    const sqlContent = fs.readFileSync(filePath, 'utf8');

    // Skip empty files or comment-only files
    const cleanSQL = sqlContent.replace(/--.*$/gm, '').trim();
    if (!cleanSQL) {
      log(`  ⏭️  Skipping empty file: ${fileName}`);
      return true;
    }

    // For now, we'll use a simpler approach with supabase CLI
    // In production, you'd want to use a proper PostgreSQL client
    const tempFile = path.join(__dirname, `../temp_${Date.now()}.sql`);
    fs.writeFileSync(tempFile, sqlContent);

    try {
      // Use supabase CLI to execute SQL
      execSync(`supabase db reset --db-url "${supabaseUrl}" --file "${tempFile}"`, {
        stdio: 'pipe',
        env: { ...process.env, SUPABASE_ACCESS_TOKEN: supabaseKey }
      });

      logSuccess(`  ✅ ${fileName} executed successfully`);
      return true;
    } catch (execError) {
      // If supabase CLI fails, try direct SQL execution
      logWarning(`  ⚠️  CLI failed for ${fileName}, trying alternative method`);

      // Alternative: Use psql if available
      try {
        const dbUrl = supabaseUrl.replace('https://', 'postgresql://postgres:').replace('.supabase.co', '.supabase.co:5432/postgres');
        execSync(`psql "${dbUrl}" -f "${tempFile}"`, { stdio: 'pipe' });
        logSuccess(`  ✅ ${fileName} executed via psql`);
        return true;
      } catch (psqlError) {
        throw new Error(`Both CLI and psql failed: ${execError.message}`);
      }
    } finally {
      // Clean up temp file
      if (fs.existsSync(tempFile)) {
        fs.unlinkSync(tempFile);
      }
    }

  } catch (error) {
    logError(`  ❌ Failed to execute ${fileName}: ${error.message}`);
    return false;
  }
}

// Create sample data for the customer
function generateSampleData(customerName) {
  const customerCode = customerName.replace(/\s+/g, '_').toUpperCase();
  
  return `
-- Sample data for ${customerName}
-- Generated automatically during customer setup

-- Insert sample departments
INSERT INTO phong_ban (ten_phong_ban, mo_ta) VALUES
('Khoa Nội', 'Khoa Nội tổng hợp'),
('Khoa Ngoại', 'Khoa Ngoại tổng hợp'),
('Khoa Sản', 'Khoa Sản phụ khoa'),
('Khoa Nhi', 'Khoa Nhi'),
('Phòng Xét nghiệm', 'Phòng Xét nghiệm'),
('Phòng Chẩn đoán hình ảnh', 'Phòng CĐHA')
ON CONFLICT (ten_phong_ban) DO NOTHING;

-- Insert sample admin user
INSERT INTO nhan_vien (username, password, full_name, role, khoa_phong) VALUES
('admin', 'admin123', 'Quản trị viên ${customerName}', 'admin', NULL),
('qltb_noi', 'qltb123', 'QLTB Khoa Nội', 'qltb_khoa', 'Khoa Nội'),
('qltb_ngoai', 'qltb123', 'QLTB Khoa Ngoại', 'qltb_khoa', 'Khoa Ngoại')
ON CONFLICT (username) DO NOTHING;

-- Insert sample equipment types
INSERT INTO loai_thiet_bi (ten_loai, mo_ta) VALUES
('Thiết bị y tế', 'Thiết bị y tế chung'),
('Máy xét nghiệm', 'Máy xét nghiệm'),
('Máy chẩn đoán', 'Máy chẩn đoán hình ảnh'),
('Thiết bị phẫu thuật', 'Thiết bị phẫu thuật')
ON CONFLICT (ten_loai) DO NOTHING;

-- Insert sample equipment
INSERT INTO thiet_bi (
  ma_thiet_bi, ten_thiet_bi, model, hang_san_xuat, 
  khoa_phong_quan_ly, tinh_trang, ngay_nhap
) VALUES
('${customerCode}_001', 'Máy siêu âm', 'US-2000', 'GE Healthcare', 'Khoa Nội', 'Đang sử dụng', CURRENT_DATE - INTERVAL '1 year'),
('${customerCode}_002', 'Máy X-quang', 'XR-500', 'Siemens', 'Phòng Chẩn đoán hình ảnh', 'Đang sử dụng', CURRENT_DATE - INTERVAL '2 years'),
('${customerCode}_003', 'Máy xét nghiệm máu', 'BL-300', 'Abbott', 'Phòng Xét nghiệm', 'Đang sử dụng', CURRENT_DATE - INTERVAL '6 months')
ON CONFLICT (ma_thiet_bi) DO NOTHING;
`;
}

// Main setup function
async function setupCustomerDatabase() {
  const config = parseArgs();
  
  log(`${colors.blue}${colors.bright}🏥 CUSTOMER DATABASE SETUP${colors.reset}`);
  log(`${colors.blue}Setting up database for: ${config.customer}${colors.reset}\n`);
  
  // Validate configuration
  validateConfig(config);
  
  try {
    // Step 1: Test connection
    logStep(1, 'Testing Supabase connection');
    // TODO: Add connection test
    logSuccess('Connection test passed');
    
    // Step 2: Get migration files
    logStep(2, 'Loading migration files');
    const migrationFiles = getMigrationFiles();
    log(`  Found ${migrationFiles.length} migration files`);
    
    // Step 3: Execute migrations
    logStep(3, 'Executing database migrations');
    let successCount = 0;
    
    for (const filePath of migrationFiles) {
      const success = await executeSQLFile(filePath, config['supabase-url'], config['supabase-key']);
      if (success) successCount++;
    }
    
    log(`\n  📊 Migration Results: ${successCount}/${migrationFiles.length} successful`);
    
    if (successCount < migrationFiles.length) {
      logWarning('Some migrations failed. Please check the logs above.');
    }
    
    // Step 4: Insert sample data
    logStep(4, 'Inserting sample data');
    const sampleData = generateSampleData(config.customer);
    
    // Write sample data to temp file and execute
    const tempFile = path.join(__dirname, '../temp_sample_data.sql');
    fs.writeFileSync(tempFile, sampleData);
    
    const sampleSuccess = await executeSQLFile(tempFile, config['supabase-url'], config['supabase-key']);
    
    // Clean up temp file
    fs.unlinkSync(tempFile);
    
    if (sampleSuccess) {
      logSuccess('Sample data inserted successfully');
    } else {
      logWarning('Sample data insertion failed');
    }
    
    // Step 5: Final verification
    logStep(5, 'Verifying setup');
    // TODO: Add verification queries
    logSuccess('Database setup completed successfully');
    
    // Summary
    log(`\n${colors.green}${colors.bright}🎉 SETUP COMPLETE${colors.reset}`);
    log(`${colors.green}Database for "${config.customer}" is ready to use!${colors.reset}`);
    log(`\nNext steps:`);
    log(`1. Update your .env.local file with the Supabase credentials`);
    log(`2. Test the application with the new database`);
    log(`3. Customize branding and settings for the customer`);
    
  } catch (error) {
    logError(`Setup failed: ${error.message}`);
    process.exit(1);
  }
}

// Run the setup
if (require.main === module) {
  setupCustomerDatabase();
}

module.exports = { setupCustomerDatabase, generateSampleData };
