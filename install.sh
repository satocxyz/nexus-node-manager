#!/bin/bash

REPO_DIR=$(pwd)
INSTALLER_NAME="install.sh"
DASHBOARD_SCRIPT="launch_nexus_dashboard.sh"
UPDATER_SCRIPT="nexus_updater.sh"

echo "📦 Installing Nexus Node Manager..."
echo ""

# 1. Install required packages
echo "🔧 Checking and installing required packages..."
sudo apt update -y && sudo apt install -y jq curl screen

# 2. Make scripts executable
echo ""
echo "🔐 Setting executable permissions..."
chmod +x "$DASHBOARD_SCRIPT" "$UPDATER_SCRIPT"

# 3. Confirm installed successfully
echo ""
echo "✅ Installation complete!"
echo "📁 Current directory: $REPO_DIR"
echo ""

# 4. Credit
echo "👤 Script by: satocxyz"
echo "🔗 GitHub: https://github.com/satocxyz"
echo "🐦 X (Twitter): https://x.com/satocxyz"
echo ""

# 5. Ask to launch the dashboard
read -rp "🚀 Do you want to launch the Nexus dashboard now? (y/n): " answer
answer=$(echo "$answer" | tr '[:upper:]' '[:lower:]')

if [[ "$answer" =~ ^(y|yes)$ ]]; then
    echo ""
    ./$DASHBOARD_SCRIPT
elif [[ "$answer" =~ ^(n|no)$ ]]; then
    echo "👍 You can start it anytime by running:"
    echo "./$DASHBOARD_SCRIPT"
else
    echo "⚠️ Invalid input. Expected 'y' or 'n'. Exiting without launching."
fi
