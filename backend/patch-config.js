const fs = require('fs');
const os = require('os');
const path = require('path');

const openclawConfigPath = path.join(os.homedir(), '.openclaw', 'openclaw.json');

if (!fs.existsSync(openclawConfigPath)) {
  console.log('No openclaw.json found. Skipping auth patch.');
  process.exit(0);
}

try {
  let config = JSON.parse(fs.readFileSync(openclawConfigPath, 'utf8'));

  if (!config.gateway) {
    config.gateway = {};
  }
  
  if (!config.gateway.controlUi) {
    config.gateway.controlUi = {};
  }

  let changed = false;
  if (!config.gateway.controlUi.dangerouslyDisableDeviceAuth) {
    config.gateway.controlUi.dangerouslyDisableDeviceAuth = true;
    changed = true;
  }
  
  if (!config.gateway.controlUi.allowInsecureAuth) {
    config.gateway.controlUi.allowInsecureAuth = true;
    changed = true;
  }

  // Ensure commands.bash is enabled (required by OpenClaw 2026.3.12+)
  if (!config.commands) config.commands = {};
  if (!config.commands.bash) {
    config.commands.bash = true;
    config.commands.restart = true;
    config.commands.native = 'auto';
    config.commands.nativeSkills = 'auto';
    changed = true;
  }

  if (changed) {
    fs.writeFileSync(openclawConfigPath, JSON.stringify(config, null, 2));
    console.log('Successfully patched openclaw.json to allow local loopback backend connections.');
  } else {
    console.log('openclaw.json already configured for local backend connections.');
  }
} catch (error) {
  console.error('Failed to patch openclaw.json:', error.message);
  process.exit(1);
}
