#!/usr/bin/env node

/**
 * 🔐 TEST LEGACY-ONLY AUTHENTICATION SYSTEM
 * 
 * Script để test hệ thống authentication chỉ dùng plaintext password
 * 
 * Usage:
 *   node scripts/test-legacy-auth.js
 */

const fs = require('fs');

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

// Test Supabase connection
async function testSupabaseConnection(env) {
  try {
    const { createClient } = await import('@supabase/supabase-js');
    
    if (!env.NEXT_PUBLIC_SUPABASE_URL || !env.NEXT_PUBLIC_SUPABASE_ANON_KEY) {
      throw new Error('Missing Supabase credentials');
    }
    
    const supabase = createClient(
      env.NEXT_PUBLIC_SUPABASE_URL,
      env.NEXT_PUBLIC_SUPABASE_ANON_KEY
    );
    
    // Test basic connection
    const { data, error } = await supabase
      .from('nhan_vien')
      .select('count')
      .limit(1);
    
    if (error) {
      throw error;
    }
    
    logSuccess('Supabase connection successful');
    return supabase;
  } catch (error) {
    logError(`Supabase connection failed: ${error.message}`);
    return null;
  }
}

// Test legacy authentication (plaintext only)
async function testLegacyAuth(supabase, username, password) {
  try {
    log(`\n🔐 Testing LEGACY authentication: ${username}/${password}`);
    
    // Get user data directly from database
    const { data: userData, error: userError } = await supabase
      .from('nhan_vien')
      .select('*')
      .eq('username', username.trim())
      .single();
    
    if (userError || !userData) {
      logError(`User lookup failed: ${userError?.message || 'User not found'}`);
      return false;
    }
    
    log(`📊 User found:`)
    log(`   ID: ${userData.id}`)
    log(`   Username: ${userData.username}`)
    log(`   Full Name: ${userData.full_name || 'null'}`);
    log(`   Role: ${userData.role || 'null'}`);
    log(`   Department: ${userData.khoa_phong || 'null'}`);
    log(`   Password Type: ${userData.password === 'hashed password' ? '❌ Hashed (not supported)' : '✅ Plaintext'}`);
    
    // Check if password is suspicious
    if (password === 'hashed password' || 
        password.includes('hash') || 
        password.includes('crypt') || 
        password.length > 200) {
      logWarning('Blocked suspicious password attempt');
      return false;
    }
    
    // Check plaintext password only
    if (userData.password === password && userData.password !== 'hashed password') {
      logSuccess(`Legacy authentication successful for ${username}`);
      log(`   🎉 Login would succeed in legacy-only mode`);
      return true;
    } else if (userData.password === 'hashed password') {
      logWarning(`User ${username} has hashed password - NOT supported in legacy mode`);
      return false;
    } else {
      logError(`Password incorrect for ${username}`);
      return false;
    }
    
  } catch (error) {
    logError(`Legacy authentication test failed: ${error.message}`);
    return false;
  }
}

// Check which users will work in legacy mode
async function checkLegacyCompatibility(supabase) {
  try {
    log(`\n🔍 Checking which users are compatible with legacy-only mode:`);
    
    const { data: allUsers, error } = await supabase
      .from('nhan_vien')
      .select('id, username, full_name, role, password')
      .order('username');
    
    if (error) {
      throw error;
    }
    
    let legacyCount = 0;
    let hashedCount = 0;
    
    for (const user of allUsers) {
      if (user.password === 'hashed password' || !user.password) {
        log(`   ❌ ${user.username} - Hashed/Empty password (won't work)`);
        hashedCount++;
      } else {
        log(`   ✅ ${user.username} - Plaintext password (will work)`);
        legacyCount++;
      }
    }
    
    log(`\n📊 Compatibility Summary:`);
    log(`   ✅ Legacy compatible users: ${legacyCount}`);
    log(`   ❌ Hashed password users: ${hashedCount}`);
    log(`   📁 Total users: ${allUsers.length}`);
    
    if (legacyCount === 0) {
      logError('NO USERS WILL BE ABLE TO LOGIN in legacy-only mode!');
      log('\n💡 Solutions:');
      log('   1. Keep dual mode authentication');
      log('   2. Convert hashed password users to plaintext');
      log('   3. Create new plaintext users for testing');
    } else if (hashedCount > 0) {
      logWarning(`${hashedCount} users will NOT be able to login in legacy-only mode`);
    } else {
      logSuccess('All users are compatible with legacy-only mode');
    }
    
  } catch (error) {
    logError(`Legacy compatibility check failed: ${error.message}`);
  }
}

// Main test function
async function testLegacyAuthentication() {
  log(`${colors.blue}${colors.bright}⚠️  TESTING LEGACY-ONLY AUTHENTICATION SYSTEM${colors.reset}\n`);
  
  try {
    // Step 1: Load environment
    log('🔍 Step 1: Loading environment variables');
    const env = loadEnvVars();
    
    if (!env.NEXT_PUBLIC_SUPABASE_URL) {
      logError('NEXT_PUBLIC_SUPABASE_URL not found in .env.local');
      return;
    }
    
    if (!env.NEXT_PUBLIC_SUPABASE_ANON_KEY) {
      logError('NEXT_PUBLIC_SUPABASE_ANON_KEY not found in .env.local');
      return;
    }
    
    logSuccess('Environment variables loaded');
    
    // Step 2: Test Supabase connection
    log('\n🔗 Step 2: Testing Supabase connection');
    const supabase = await testSupabaseConnection(env);
    
    if (!supabase) {
      logError('Cannot proceed without Supabase connection');
      return;
    }
    
    // Step 3: Check legacy compatibility
    await checkLegacyCompatibility(supabase);
    
    // Step 4: Test specific users with plaintext passwords
    log('\n👥 Step 4: Testing legacy authentication');
    
    const testUsers = [
      { username: 'admin', password: 'admin123' },
      { username: 'to_qltb', password: 'qltb123' },
      { username: 'test_user', password: 'password123' }
    ];
    
    let successCount = 0;
    
    for (const testUser of testUsers) {
      const authSuccess = await testLegacyAuth(supabase, testUser.username, testUser.password);
      if (authSuccess) {
        successCount++;
      }
    }
    
    // Step 5: Summary
    log(`\n${colors.green}${colors.bright}📊 LEGACY TEST SUMMARY${colors.reset}`);
    log(`✅ Successful legacy authentications: ${successCount}/${testUsers.length}`);
    
    if (successCount === 0) {
      log(`\n${colors.red}❌ NO SUCCESSFUL LEGACY AUTHENTICATIONS${colors.reset}`);
      log('\n💡 This means:');
      log('   - Legacy-only mode will NOT work with current users');
      log('   - Users with hashed passwords cannot login in legacy mode');
      log('   - You need plaintext passwords to use legacy-only mode');
      
      log('\n🔧 Recommended actions:');
      log('   1. Keep dual mode authentication (current setup)');
      log('   2. Or create new users with plaintext passwords');
      log('   3. Or convert existing users to plaintext (security risk!)');
    } else if (successCount < testUsers.length) {
      log(`\n${colors.yellow}⚠️ PARTIAL SUCCESS${colors.reset}`);
      log('   Some accounts work in legacy mode, others don\'t');
    } else {
      log(`\n${colors.green}🎉 ALL LEGACY TESTS PASSED${colors.reset}`);
      log('   Legacy-only authentication mode will work');
    }
    
    log(`\n${colors.cyan}🔧 Implementation Status:${colors.reset}`);
    log('   ✅ SQL script ready: scripts/disable-hashed-auth.sql');
    log('   ✅ Frontend updated: src/contexts/auth-context.tsx');
    log('   ⚠️  Run SQL script in Supabase to complete the switch');
    
  } catch (error) {
    logError(`Test failed: ${error.message}`);
    console.error(error);
  }
}

// Run the test
if (require.main === module) {
  testLegacyAuthentication();
}

module.exports = { testLegacyAuthentication };
