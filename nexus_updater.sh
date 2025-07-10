{\rtf1\ansi\ansicpg1252\cocoartf2822
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fswiss\fcharset0 Helvetica;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
\paperw11900\paperh16840\margl1440\margr1440\vieww11520\viewh8400\viewkind0
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0

\f0\fs24 \cf0 #!/bin/bash\
\
CONFIG_DIR="$HOME/.nexus-dashboard"\
CONFIG_FILE="$CONFIG_DIR/nodes.conf"\
\
mkdir -p "$CONFIG_DIR"\
\
# Function to get current installed version\
get_installed_version() \{\
    if command -v nexus-network &> /dev/null; then\
        nexus-network --version | awk '\{print $2\}'\
    else\
        echo "not_installed"\
    fi\
\}\
\
# Function to get latest GitHub release version\
get_latest_version() \{\
    curl -s https://api.github.com/repos/nexus-xyz/nexus-cli/releases/latest | jq -r '.tag_name' | sed 's/^v//'\
\}\
\
# Function to check running nexus_* screens\
running_nexus_screens() \{\
    screen -ls | grep -oE '\\t[0-9]+\\.(nexus_[^\\s]+)' | sed 's/^\\t//' || true\
\}\
\
# Function to prompt and collect node IDs\
collect_node_ids() \{\
    echo ""\
    echo "\uc0\u55357 \u56610  How many node IDs do you want to run?"\
    read -rp "> " NODE_COUNT\
\
    if ! [[ "$NODE_COUNT" =~ ^[0-9]+$ ]] || [ "$NODE_COUNT" -le 0 ]; then\
        echo "\uc0\u10060  Invalid number. Exiting."\
        exit 1\
    fi\
\
    NODE_IDS=()\
    for ((i = 1; i <= NODE_COUNT; i++)); do\
        read -rp "\uc0\u55356 \u56724  Enter Node ID #$i: " NODE_ID\
        NODE_IDS+=("$NODE_ID")\
    done\
\
    printf "%s\\n" "$\{NODE_IDS[@]\}" > "$CONFIG_FILE"\
    echo "\uc0\u55357 \u56510  Saved to $CONFIG_FILE"\
\}\
\
# Function to load existing config or prompt\
load_or_prompt_node_ids() \{\
    if [[ -f "$CONFIG_FILE" ]]; then\
        echo "\uc0\u55357 \u56513  Found saved Node IDs:"\
        cat "$CONFIG_FILE"\
        echo ""\
        echo "\uc0\u10067  Do you want to use this list? (y/n)"\
        read -rp "> " use_saved\
\
        case "$\{use_saved,,\}" in\
            y|yes)\
                mapfile -t NODE_IDS < "$CONFIG_FILE"\
                ;;\
            n|no)\
                collect_node_ids\
                ;;\
            *)\
                echo "\uc0\u10060  Invalid input. Please enter 'y' or 'n'. Exiting."\
                exit 1\
                ;;\
        esac\
    else\
        collect_node_ids\
    fi\
\}\
\
# Function to kill all existing nexus_* screens\
kill_nexus_screens() \{\
    echo "\uc0\u55358 \u56825  Cleaning up old screen sessions..."\
    while read -r screen_line; do\
        screen_id=$(echo "$screen_line" | awk -F. '\{print $1\}')\
        screen -S "$screen_id" -X quit\
    done <<< "$(running_nexus_screens)"\
\}\
\
# Function to start all nodes\
start_nodes() \{\
    for NODE_ID in "$\{NODE_IDS[@]\}"; do\
        SCREEN_NAME="nexus_$NODE_ID"\
        echo "  \uc0\u55357 \u56960  Starting node in screen session $SCREEN_NAME"\
        screen -dmS "$SCREEN_NAME" bash -c "nexus-network start --node-id $NODE_ID; exec bash"\
    done\
\}\
\
# MAIN LOOP\
while true; do\
    echo "\uc0\u55357 \u56658  Checking for Nexus CLI update at $(date)"\
\
    INSTALLED_VERSION=$(get_installed_version)\
    LATEST_VERSION=$(get_latest_version)\
\
    echo "\uc0\u55357 \u56589  Installed version: $INSTALLED_VERSION"\
    echo "\uc0\u55356 \u57104  Latest version from GitHub: v$LATEST_VERSION"\
\
    if [[ "$INSTALLED_VERSION" == "not_installed" || "$INSTALLED_VERSION" != "$LATEST_VERSION" ]]; then\
        echo "\uc0\u11014 \u65039   New version found. Updating Nexus CLI..."\
        NONINTERACTIVE=1 curl -s https://cli.nexus.xyz/ | sh\
\
        echo "\uc0\u9989  Nexus CLI updated to version v$LATEST_VERSION"\
        load_or_prompt_node_ids\
        kill_nexus_screens\
        echo ""\
        for NODE_ID in "$\{NODE_IDS[@]\}"; do\
            echo "\uc0\u55357 \u56577  Restarting node $NODE_ID..."\
            SCREEN_NAME="nexus_$NODE_ID"\
            echo "  \uc0\u55357 \u56960  Starting node in screen session $SCREEN_NAME"\
            screen -dmS "$SCREEN_NAME" bash -c "nexus-network start --node-id $NODE_ID; exec bash"\
        done\
        echo "\uc0\u9989  All nodes restarted with updated CLI."\
    else\
        echo "\uc0\u9989  Already up to date."\
\
        if [[ -z "$(running_nexus_screens)" ]]; then\
            echo "\uc0\u9888 \u65039   No running nodes detected. Starting saved nodes..."\
            load_or_prompt_node_ids\
            start_nodes\
        else\
            echo "\uc0\u9989  Nodes are already running. No action taken."\
        fi\
    fi\
\
    echo "\uc0\u55357 \u56741 \u65039   Currently running nexus_* screen sessions:"\
    running_nexus_screens\
\
    echo ""\
    echo "\uc0\u9203  Sleeping for 1 hour..."\
    sleep 3600\
done\
}