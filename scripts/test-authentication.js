#!/usr/bin/env node

/**
 * 🔐 TEST AUTHENTICATION SYSTEM
 * 
 * Script để test hệ thống authentication và chẩn đoán vấn đề đăng nhập
 * 
 * Usage:
 *   node scripts/test-authentication.js
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

// Test authentication function
async function testAuthFunction(supabase, username, password) {
  try {
    log(`\n🔐 Testing authentication: ${username}/${password}`);
    
    const { data, error } = await supabase.rpc('authenticate_user_dual_mode', {
      p_username: username,
      p_password: password
    });
    
    if (error) {
      logError(`RPC Error: ${error.message}`);
      return false;
    }
    
    if (!data || !Array.isArray(data) || data.length === 0) {
      logError('No data returned from authentication function');
      return false;
    }
    
    const result = data[0];
    
    log(`📊 Authentication result:`);
    log(`   User ID: ${result.user_id || 'null'}`);
    log(`   Username: ${result.username || 'null'}`);
    log(`   Full Name: ${result.full_name || 'null'}`);
    log(`   Role: ${result.role || 'null'}`);
    log(`   Department: ${result.khoa_phong || 'null'}`);
    log(`   Authenticated: ${result.is_authenticated ? '✅ Yes' : '❌ No'}`);
    log(`   Auth Mode: ${result.authentication_mode || 'unknown'}`);
    
    if (result.is_authenticated) {
      logSuccess(`Authentication successful for ${username}`);
      return true;
    } else {
      logWarning(`Authentication failed for ${username}: ${result.authentication_mode}`);
      return false;
    }
    
  } catch (error) {
    logError(`Authentication test failed: ${error.message}`);
    return false;
  }
}

// Test user existence
async function testUserExistence(supabase, username) {
  try {
    const { data, error } = await supabase
      .from('nhan_vien')
      .select('id, username, full_name, role, khoa_phong, password, hashed_password')
      .eq('username', username)
      .single();
    
    if (error) {
      if (error.code === 'PGRST116') {
        logWarning(`User ${username} does not exist`);
        return null;
      }
      throw error;
    }
    
    log(`\n👤 User ${username} details:`);
    log(`   ID: ${data.id}`);
    log(`   Full Name: ${data.full_name || 'null'}`);
    log(`   Role: ${data.role || 'null'}`);
    log(`   Department: ${data.khoa_phong || 'null'}`);
    log(`   Password: ${data.password ? (data.password === 'hashed password' ? '✅ Hashed marker' : '⚠️ Plain text') : '❌ Empty'}`);
    log(`   Hashed Password: ${data.hashed_password ? '✅ Present' : '❌ Missing'}`);
    
    return data;
  } catch (error) {
    logError(`User check failed: ${error.message}`);
    return null;
  }
}

// Check if authentication function exists
async function checkAuthFunction(supabase) {
  try {
    const { data, error } = await supabase.rpc('authenticate_user_dual_mode', {
      p_username: 'test_nonexistent_user',
      p_password: 'test'
    });
    
    // If we get here without error, function exists
    logSuccess('authenticate_user_dual_mode function exists');
    return true;
  } catch (error) {
    if (error.message.includes('function authenticate_user_dual_mode') || 
        error.message.includes('does not exist')) {
      logError('authenticate_user_dual_mode function does not exist');
      return false;
    }
    // Other errors mean function exists but failed for other reasons
    logSuccess('authenticate_user_dual_mode function exists');
    return true;
  }
}

// Main test function
async function testAuthentication() {
  log(`${colors.blue}${colors.bright}🔐 TESTING AUTHENTICATION SYSTEM${colors.reset}\n`);
  
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
    
    // Step 3: Check authentication function
    log('\n🔧 Step 3: Checking authentication function');
    const functionExists = await checkAuthFunction(supabase);
    
    if (!functionExists) {
      logError('Authentication function missing! Run fix-authentication-issue.sql first');
      log('\n💡 To fix:');
      log('   1. Copy content of scripts/fix-authentication-issue.sql');
      log('   2. Run in Supabase SQL Editor');
      log('   3. Run this test again');
      return;
    }
    
    // Step 4: Test specific users
    log('\n👥 Step 4: Testing user accounts');
    
    const testUsers = [
      { username: 'ntchi', password: 'admin' },
      { username: 'admin', password: 'admin123' },
      { username: 'to_qltb', password: 'qltb123' }
    ];
    
    let successCount = 0;
    
    for (const testUser of testUsers) {
      // Check if user exists
      const userData = await testUserExistence(supabase, testUser.username);
      
      if (userData) {
        // Test authentication
        const authSuccess = await testAuthFunction(supabase, testUser.username, testUser.password);
        if (authSuccess) {
          successCount++;
        }
      }
    }
    
    // Step 5: Summary
    log(`\n${colors.green}${colors.bright}📊 TEST SUMMARY${colors.reset}`);
    log(`✅ Successful authentications: ${successCount}/${testUsers.length}`);
    
    if (successCount === 0) {
      log(`\n${colors.red}❌ NO SUCCESSFUL AUTHENTICATIONS${colors.reset}`);
      log('\n💡 Possible solutions:');
      log('   1. Run scripts/fix-authentication-issue.sql in Supabase SQL Editor');
      log('   2. Check if users exist in database');
      log('   3. Verify passwords are correct');
      log('   4. Check Supabase permissions');
    } else if (successCount < testUsers.length) {
      log(`\n${colors.yellow}⚠️ PARTIAL SUCCESS${colors.reset}`);
      log('   Some accounts work, others may need fixing');
    } else {
      log(`\n${colors.green}🎉 ALL TESTS PASSED${colors.reset}`);
      log('   Authentication system is working correctly');
    }
    
  } catch (error) {
    logError(`Test failed: ${error.message}`);
    console.error(error);
  }
}

// Run the test
if (require.main === module) {
  testAuthentication();
}

module.exports = { testAuthentication };
