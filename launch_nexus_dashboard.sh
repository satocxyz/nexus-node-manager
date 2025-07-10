#!/bin/bash

DASHBOARD_SCREEN="nexus_dashboard"
SCRIPT_NAME="nexus_updater.sh"

# Ensure nexus_updater.sh is executable
chmod +x "$SCRIPT_NAME"

# Kill old dashboard screen if it's running
if screen -list | grep -q "$DASHBOARD_SCREEN"; then
    echo "🔁 An old '$DASHBOARD_SCREEN' session is running. Terminating..."
    screen -S "$DASHBOARD_SCREEN" -X quit
fi

# Start new dashboard screen
echo "🚀 Launching Nexus Node Manager in screen session '$DASHBOARD_SCREEN'..."
screen -dmS "$DASHBOARD_SCREEN" bash -c "./$SCRIPT_NAME; exec bash"

# Confirm
echo "✅ Nexus Node Manager is now running inside screen: $DASHBOARD_SCREEN"
echo ""

# Show running node screens
echo "📋 Running screen sessions (node processes):"
screen -ls | grep "nexus_"

echo ""
echo "📺 To monitor the dashboard, run:"
echo "screen -r $DASHBOARD_SCREEN"
echo ""
echo "🔌 To detach from the screen safely, press:"
echo "Ctrl + A, then D"
