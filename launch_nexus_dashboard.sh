#!/bin/bash

DASHBOARD_SCREEN="nexus_dashboard"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
UPDATER_SCRIPT="$SCRIPT_DIR/nexus_updater.sh"

# Check if updater script exists
if [[ ! -f "$UPDATER_SCRIPT" ]]; then
    echo "❌ nexus_updater.sh not found in $SCRIPT_DIR"
    exit 1
fi

# Start the updater in a detached screen session with clear output
echo "🚀 Launching Nexus Node Manager in screen session '$DASHBOARD_SCREEN'..."
screen -dmS "$DASHBOARD_SCREEN" bash -c "clear && $UPDATER_SCRIPT; exec bash"

# Wait a bit to ensure everything has time to launch
sleep 3

echo ""
echo "✅ Nexus Node Manager is now running inside screen: $DASHBOARD_SCREEN"
echo ""

# Show currently running node-related screens
echo "📋 Running screen sessions (node processes):"
screen -ls | grep "nexus_" || echo "⚠️  No node screens running yet."

echo ""
echo "📺 To monitor the dashboard, run:"
echo "   screen -r $DASHBOARD_SCREEN"
echo ""
echo "🔌 To detach from the screen safely, press:"
echo "   Ctrl + A, then D"
echo ""

# Give users time to read the message before entering screen
sleep 5

# Auto-attach to the dashboard screen
screen -r "$DASHBOARD_SCREEN"
