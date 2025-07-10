# nexus-node-manager

📘 Nexus Node Manager
A simple CLI tool to manage your Nexus node lifecycle with automatic update checks, restart logic, and screen session isolation.
Built for testnet users who want set-it-and-forget-it reliability.

# 🔧 Requirements
Install these if not already available:
```
sudo apt install jq curl screen
```
Tested on Linux + WSL (Ubuntu).

# ⚙️ Installation
Clone the repo and run the installer:
```
git clone https://github.com/satocxyz/nexus-node-manager.git
cd nexus-node-manager
./install.sh
```

# 🚀 Usage
Start the node manager inside a dedicated screen session:
```
./launch_nexus_dashboard.sh
```
# 🔍 To monitor or manage:
Reattach to the dashboard screen:
```
screen -r nexus_dashboard
```
To safely detach and leave it running:
__Ctrl + A, then D__

To list all nexus_ node screens:
```
screen -ls
```

# 🧩 Node Config
Your Node IDs are saved at:
```
~/.nexus-dashboard/nodes.conf
```
The first time you run the script, you'll be asked how many nodes to start and their IDs.
Next time, you can reuse the saved list or overwrite it interactively.

# 🧹 Reset Config
To remove the saved Node ID list and start fresh:
```
rm ~/.nexus-dashboard/nodes.conf
```


