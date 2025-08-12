#!/usr/bin/env node

/**
 * 🚀 COMPLETE CUSTOMER SETUP AUTOMATION
 * 
 * This script automates the entire process of setting up a new customer:
 * 1. Creates a new GitHub repository (fork)
 * 2. Customizes branding and configurations
 * 3. Sets up Supabase database with full schema
 * 4. Prepares deployment configurations
 * 
 * Usage:
 *   node scripts/setup-new-customer.js --config=customer-config.json
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

// Load customer configuration
function loadCustomerConfig(configPath) {
  if (!fs.existsSync(configPath)) {
    logError(`Configuration file not found: ${configPath}`);
    log('\nExample configuration file (customer-config.json):');
    log(JSON.stringify({
      customer: {
        name: "Bệnh viện ABC",
        code: "BV_ABC",
        domain: "bv-abc.com",
        contact: {
          email: "admin@bv-abc.com",
          phone: "+84 123 456 789"
        }
      },
      branding: {
        appName: "Quản lý TBYT - BV ABC",
        shortName: "TBYT ABC",
        primaryColor: "#2563eb",
        logo: "/assets/bv-abc-logo.png"
      },
      supabase: {
        url: "https://xxx.supabase.co",
        anonKey: "eyJ...",
        serviceKey: "eyJ..."
      },
      github: {
        repoName: "bv-abc-medical-equipment",
        orgName: "your-org"
      },
      features: {
        enableQRScanner: true,
        enableReports: true,
        enableTransfers: true
      }
    }, null, 2));
    process.exit(1);
  }
  
  try {
    const config = JSON.parse(fs.readFileSync(configPath, 'utf8'));
    return config;
  } catch (error) {
    logError(`Failed to parse configuration file: ${error.message}`);
    process.exit(1);
  }
}

// Validate customer configuration
function validateConfig(config) {
  const required = [
    'customer.name',
    'customer.code',
    'branding.appName',
    'supabase.url',
    'supabase.anonKey',
    'github.repoName'
  ];
  
  const missing = required.filter(path => {
    const keys = path.split('.');
    let obj = config;
    for (const key of keys) {
      if (!obj || !obj[key]) return true;
      obj = obj[key];
    }
    return false;
  });
  
  if (missing.length > 0) {
    logError(`Missing required configuration: ${missing.join(', ')}`);
    return false;
  }
  
  return true;
}

// Create GitHub repository (fork)
function createGitHubRepo(config) {
  const { repoName, orgName } = config.github;
  
  try {
    // Check if GitHub CLI is available
    execSync('gh --version', { stdio: 'ignore' });
    
    log(`  Creating GitHub repository: ${repoName}`);
    
    // Fork the repository
    const forkCommand = orgName 
      ? `gh repo fork --org ${orgName} --repo-name ${repoName}`
      : `gh repo fork --repo-name ${repoName}`;
    
    execSync(forkCommand, { stdio: 'inherit' });
    
    logSuccess(`Repository created: ${repoName}`);
    return true;
  } catch (error) {
    logError(`Failed to create GitHub repository: ${error.message}`);
    logWarning('Please create the repository manually and continue with customization');
    return false;
  }
}

// Customize branding and configurations
function customizeBranding(config) {
  const { customer, branding } = config;
  
  // Update package.json
  const packagePath = path.join(__dirname, '../package.json');
  if (fs.existsSync(packagePath)) {
    const packageJson = JSON.parse(fs.readFileSync(packagePath, 'utf8'));
    packageJson.name = customer.code.toLowerCase().replace(/_/g, '-');
    packageJson.description = `Hệ thống quản lý thiết bị y tế - ${customer.name}`;
    fs.writeFileSync(packagePath, JSON.stringify(packageJson, null, 2));
    logSuccess('Updated package.json');
  }
  
  // Update app layout title
  const layoutPath = path.join(__dirname, '../src/app/layout.tsx');
  if (fs.existsSync(layoutPath)) {
    let layoutContent = fs.readFileSync(layoutPath, 'utf8');
    layoutContent = layoutContent.replace(
      /title: 'QUẢN LÝ TBYT CDC'/,
      `title: '${branding.appName}'`
    );
    layoutContent = layoutContent.replace(
      /description: 'Hệ thống quản lý trang thiết bị y tế'/,
      `description: 'Hệ thống quản lý thiết bị y tế - ${customer.name}'`
    );
    fs.writeFileSync(layoutPath, layoutContent);
    logSuccess('Updated app layout');
  }
  
  // Update manifest.json
  const manifestPath = path.join(__dirname, '../public/manifest.json');
  if (fs.existsSync(manifestPath)) {
    const manifest = JSON.parse(fs.readFileSync(manifestPath, 'utf8'));
    manifest.name = branding.appName;
    manifest.short_name = branding.shortName;
    manifest.description = `Ứng dụng quản lý thiết bị y tế - ${customer.name}`;
    fs.writeFileSync(manifestPath, JSON.stringify(manifest, null, 2));
    logSuccess('Updated PWA manifest');
  }
  
  // Update colors in globals.css if primary color is specified
  if (branding.primaryColor) {
    const cssPath = path.join(__dirname, '../src/app/globals.css');
    if (fs.existsSync(cssPath)) {
      // This would require more complex CSS parsing
      // For now, just log that manual update is needed
      logWarning(`Manual update needed: Update primary color to ${branding.primaryColor} in globals.css`);
    }
  }
}

// Create environment file
function createEnvironmentFile(config) {
  const { supabase } = config;
  
  const envContent = `# Environment variables for ${config.customer.name}
# Generated automatically during customer setup

# Supabase Configuration
NEXT_PUBLIC_SUPABASE_URL=${supabase.url}
NEXT_PUBLIC_SUPABASE_ANON_KEY=${supabase.anonKey}
SUPABASE_SERVICE_ROLE_KEY=${supabase.serviceKey || 'YOUR_SERVICE_ROLE_KEY'}

# Customer Information
CUSTOMER_NAME="${config.customer.name}"
CUSTOMER_CODE="${config.customer.code}"

# Features
ENABLE_QR_SCANNER=${config.features?.enableQRScanner || true}
ENABLE_REPORTS=${config.features?.enableReports || true}
ENABLE_TRANSFERS=${config.features?.enableTransfers || true}
`;

  const envPath = path.join(__dirname, '../.env.local');
  fs.writeFileSync(envPath, envContent);
  logSuccess('Created .env.local file');
}

// Setup database
async function setupDatabase(config) {
  const { setupCustomerDatabase } = require('./setup-customer-database');
  
  try {
    // Call the database setup script
    await setupCustomerDatabase({
      customer: config.customer.name,
      'supabase-url': config.supabase.url,
      'supabase-key': config.supabase.serviceKey || config.supabase.anonKey
    });
    
    logSuccess('Database setup completed');
    return true;
  } catch (error) {
    logError(`Database setup failed: ${error.message}`);
    return false;
  }
}

// Generate deployment instructions
function generateDeploymentInstructions(config) {
  const instructions = `# Deployment Instructions for ${config.customer.name}

## 🚀 Quick Deploy to Vercel

1. **Install Vercel CLI** (if not already installed):
   \`\`\`bash
   npm i -g vercel
   \`\`\`

2. **Login to Vercel**:
   \`\`\`bash
   vercel login
   \`\`\`

3. **Deploy the application**:
   \`\`\`bash
   vercel --prod
   \`\`\`

4. **Set environment variables** in Vercel dashboard:
   - NEXT_PUBLIC_SUPABASE_URL: ${config.supabase.url}
   - NEXT_PUBLIC_SUPABASE_ANON_KEY: ${config.supabase.anonKey}
   - SUPABASE_SERVICE_ROLE_KEY: [Your service role key]

## 🌐 Custom Domain Setup

1. In Vercel dashboard, go to your project settings
2. Navigate to "Domains" section
3. Add your custom domain: ${config.customer.domain || 'your-domain.com'}
4. Follow Vercel's DNS configuration instructions

## 📱 PWA Configuration

The app is already configured as a PWA. Users can install it on their devices:
- **Mobile**: Tap "Add to Home Screen" in browser menu
- **Desktop**: Click install icon in address bar

## 🔧 Post-Deployment Checklist

- [ ] Test login with admin credentials
- [ ] Verify all features work correctly
- [ ] Test on mobile devices
- [ ] Configure backup procedures
- [ ] Set up monitoring and alerts
- [ ] Train customer staff

## 📞 Support Information

For technical support, contact:
- Email: [Your support email]
- Phone: [Your support phone]
- Documentation: [Link to documentation]
`;

  const instructionsPath = path.join(__dirname, '../DEPLOYMENT_INSTRUCTIONS.md');
  fs.writeFileSync(instructionsPath, instructions);
  logSuccess('Generated deployment instructions');
}

// Main setup function
async function setupNewCustomer() {
  const configPath = process.argv.find(arg => arg.startsWith('--config='))?.split('=')[1];
  
  if (!configPath) {
    logError('Configuration file required. Use --config=customer-config.json');
    process.exit(1);
  }
  
  log(`${colors.blue}${colors.bright}🏥 NEW CUSTOMER SETUP${colors.reset}\n`);
  
  // Load and validate configuration
  const config = loadCustomerConfig(configPath);
  if (!validateConfig(config)) {
    process.exit(1);
  }
  
  log(`${colors.blue}Setting up: ${config.customer.name}${colors.reset}\n`);
  
  try {
    // Step 1: Create GitHub repository
    logStep(1, 'Creating GitHub repository');
    createGitHubRepo(config);
    
    // Step 2: Customize branding
    logStep(2, 'Customizing branding and configurations');
    customizeBranding(config);
    
    // Step 3: Create environment file
    logStep(3, 'Creating environment configuration');
    createEnvironmentFile(config);
    
    // Step 4: Setup database
    logStep(4, 'Setting up Supabase database');
    await setupDatabase(config);
    
    // Step 5: Generate deployment instructions
    logStep(5, 'Generating deployment instructions');
    generateDeploymentInstructions(config);
    
    // Success summary
    log(`\n${colors.green}${colors.bright}🎉 CUSTOMER SETUP COMPLETE${colors.reset}`);
    log(`${colors.green}${config.customer.name} is ready for deployment!${colors.reset}`);
    
    log(`\n📋 Next steps:`);
    log(`1. Review the generated DEPLOYMENT_INSTRUCTIONS.md`);
    log(`2. Test the application locally: npm run dev`);
    log(`3. Deploy to Vercel: vercel --prod`);
    log(`4. Configure custom domain if needed`);
    log(`5. Train customer staff`);
    
  } catch (error) {
    logError(`Setup failed: ${error.message}`);
    process.exit(1);
  }
}

// Run the setup
if (require.main === module) {
  setupNewCustomer();
}

module.exports = { setupNewCustomer };
