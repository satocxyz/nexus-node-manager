#!/bin/bash

CONFIG_DIR="$HOME/.nexus-dashboard"
CONFIG_FILE="$CONFIG_DIR/nodes.conf"
DASHBOARD_SCREEN="nexus_dashboard"

mkdir -p "$CONFIG_DIR"

# Ensure required commands exist
for cmd in curl jq screen; do
    if ! command -v "$cmd" &>/dev/null; then
        echo "❌ Required command '$cmd' not found. Please install it first."
        exit 1
    fi
done

# Ensure nexus-network exists, install if missing
if ! command -v nexus-network &>/dev/null; then
    echo "❗ 'nexus-network' not found. Attempting to install Nexus CLI..."
    curl -s https://cli.nexus.xyz/ | sh

    if ! command -v nexus-network &>/dev/null; then
        echo "❌ Nexus CLI installation failed. Exiting."
        exit 1
    fi
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Nexus Node Manager is running!"
echo ""
echo "💡 To exit and keep it running in background:"
echo "   👉 Press: Ctrl + A, then D"
echo ""
echo "🔁 This will keep checking for updates every hour."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Main loop
while true; do
    echo ""
    echo "🕒 Checking for Nexus CLI update at $(date)"

    INSTALLED_VERSION=$(nexus-network --version 2>/dev/null | awk '{print $2}')
    LATEST_VERSION=$(curl -s https://api.github.com/repos/nexus-xyz/nexus-cli/releases/latest | jq -r '.tag_name' | sed 's/^v//')

    echo "🔍 Installed version: $INSTALLED_VERSION"
    echo "🌐 Latest version from GitHub: v$LATEST_VERSION"

    UPDATE_REQUIRED=false
    if [[ "$INSTALLED_VERSION" != "$LATEST_VERSION" ]]; then
        echo "⬆️  New version found. Updating Nexus CLI..."
        curl -s https://cli.nexus.xyz/ | sh
        UPDATE_REQUIRED=true
        echo "✅ Nexus CLI updated to version v$LATEST_VERSION"
    fi

    # Load or collect node IDs
    NODE_IDS=()
    if [[ -f "$CONFIG_FILE" ]]; then
        echo ""
        echo "🧩 Existing node config found:"
        cat "$CONFIG_FILE"
        echo ""
        read -rp "➡️  Use existing node IDs? (y/n): " reuse
        reuse=$(echo "$reuse" | tr '[:upper:]' '[:lower:]')

        if [[ "$reuse" =~ ^(y|yes)$ ]]; then
            mapfile -t NODE_IDS <"$CONFIG_FILE"
        elif [[ "$reuse" =~ ^(n|no)$ ]]; then
            rm -f "$CONFIG_FILE"
        else
            echo "⚠️  Invalid input. Please answer with y/yes or n/no. Exiting."
            exit 1
        fi
    fi

    # If node IDs are still empty, ask for them
    if [[ ${#NODE_IDS[@]} -eq 0 ]]; then
        read -rp "🔢 How many nodes do you want to run? " NODE_COUNT

        if ! [[ "$NODE_COUNT" =~ ^[0-9]+$ ]] || [[ "$NODE_COUNT" -le 0 ]]; then
            echo "⚠️  Invalid number. Exiting."
            exit 1
        fi

        for ((i = 1; i <= NODE_COUNT; i++)); do
            read -rp "➡️  Enter node ID #$i: " node_id
            NODE_IDS+=("$node_id")
        done

        printf "%s\n" "${NODE_IDS[@]}" >"$CONFIG_FILE"
        echo "💾 Node IDs saved to $CONFIG_FILE"
    fi

    # Loop through node IDs
    for NODE_ID in "${NODE_IDS[@]}"; do
        SCREEN_NAME="nexus_$NODE_ID"

        # Restart if already running
        if screen -list | grep -q "$SCREEN_NAME"; then
            echo "🔁 Restarting node $NODE_ID..."
            screen -S "$SCREEN_NAME" -X quit
        else
            echo "🔁 Starting node $NODE_ID..."
        fi

        screen -dmS "$SCREEN_NAME" bash -c "nexus-network start --node-id $NODE_ID; exec bash"
        echo "  🚀 Started in screen: $SCREEN_NAME"
    done

    # If no update and no running screens, start them
    if [[ "$UPDATE_REQUIRED" == "false" ]]; then
        ANY_RUNNING=false
        for NODE_ID in "${NODE_IDS[@]}"; do
            SCREEN_NAME="nexus_$NODE_ID"
            if screen -list | grep -q "$SCREEN_NAME"; then
                ANY_RUNNING=true
                break
            fi
        done

        if [[ "$ANY_RUNNING" == "false" ]]; then
            echo "⚠️  No nodes are currently running. Starting all nodes..."
            for NODE_ID in "${NODE_IDS[@]}"; do
                SCREEN_NAME="nexus_$NODE_ID"
                screen -dmS "$SCREEN_NAME" bash -c "nexus-network start --node-id $NODE_ID; exec bash"
                echo "  🚀 Started in screen: $SCREEN_NAME"
            done
        else
            echo "✅ No update needed and nodes are already running."
        fi
    fi

    echo ""
    echo "📋 Running node screens:"
    screen -ls | grep "nexus_" || echo "⚠️  No node screens found."

    echo ""
    echo "📺 To attach to a node screen:"
    echo "   screen -r nexus_<node_id>  (e.g. screen -r nexus_14425146)"
    echo ""
    echo "🔌 To detach from screen safely:"
    echo "   👉 Press: Ctrl + A, then D"
    echo ""
    echo "⏳ Sleeping for 1 hour..."
    sleep 3600
done
