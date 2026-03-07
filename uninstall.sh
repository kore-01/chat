#!/bin/bash
set -e

# Configuration
INSTALL_DIR="$HOME/OpenClaw-Chat-Gateway"
SERVICE_NAME="clawui.service"
SERVICE_PATH="$HOME/.config/systemd/user/$SERVICE_NAME"

# Terminal Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${RED}================================================${NC}"
echo -e "${RED}   OpenClaw Chat Gateway - Uninstaller          ${NC}"
echo -e "${RED}================================================${NC}"

# Detect if we are running from the installation folder or via curl
if [ -f "./uninstall.sh" ]; then
    PROJECT_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
else
    PROJECT_ROOT="$INSTALL_DIR"
fi

# Confirm Uninstallation
echo -e "${RED}WARNING: This will stop the service and delete ALL data in:${NC}"
echo -e " - $PROJECT_ROOT"
echo -e " - ~/.clawui_dev"
echo -e " - ~/.clawui_release"
echo ""
read -p "Are you sure you want to proceed? (y/N) " confirm
if [[ ! $confirm =~ ^[Yy]$ ]]; then
    echo "Uninstallation cancelled."
    exit 0
fi

# Stop and Remove Services
echo -e "\n${BLUE}Step 1: Stopping and removing services...${NC}"
systemctl --user stop $SERVICE_NAME 2>/dev/null || true
systemctl --user disable $SERVICE_NAME 2>/dev/null || true

if [ -f "$SERVICE_PATH" ]; then
    rm "$SERVICE_PATH"
    echo "Removed systemd service file."
fi

systemctl --user daemon-reload

# Remove Data and Logs
echo -e "\n${BLUE}Step 2: Clearing all data and settings...${NC}"
rm -rf "$HOME/.clawui_dev"
rm -rf "$HOME/.clawui_release"
echo "Deleted data directories: ~/.clawui_dev, ~/.clawui_release"

# Remove Project Files
echo -e "\n${BLUE}Step 3: Removing project files...${NC}"
if [ -d "$PROJECT_ROOT" ]; then
    rm -rf "$PROJECT_ROOT"
    echo "Deleted project folder: $PROJECT_ROOT"
else
    echo "Project folder $PROJECT_ROOT not found, skipping."
fi

echo -e "\n${GREEN}================================================${NC}"
echo -e "${GREEN}   Uninstallation Complete!                     ${NC}"
echo -e "${GREEN}================================================${NC}"
