{\rtf1\ansi\ansicpg1252\cocoartf2822
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fswiss\fcharset0 Helvetica;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
\paperw11900\paperh16840\margl1440\margr1440\vieww11520\viewh8400\viewkind0
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0

\f0\fs24 \cf0 #!/bin/bash\
\
# Set script files to be executable\
chmod +x launch_nexus_dashboard.sh\
chmod +x nexus_updater.sh\
\
echo ""\
echo "\uc0\u9989  Nexus Node Manager scripts are now executable."\
\
# Show usage instructions\
echo ""\
echo "\uc0\u55357 \u56514  Files installed:"\
echo "  - launch_nexus_dashboard.sh  \uc0\u8594  Launches the dashboard screen"\
echo "  - nexus_updater.sh           \uc0\u8594  Main update and node manager"\
echo ""\
echo "\uc0\u55357 \u56960  Usage:"\
echo "  ./launch_nexus_dashboard.sh"\
\
# Prompt to auto-launch\
echo ""\
read -rp "\uc0\u10067  Do you want to launch the dashboard now? (y/n) " confirm\
\
case "$\{confirm,,\}" in\
    y|yes)\
        echo "\uc0\u55357 \u56960  Launching dashboard..."\
        ./launch_nexus_dashboard.sh\
        ;;\
    n|no)\
        echo "\uc0\u55357 \u56397  You can launch it later with: ./launch_nexus_dashboard.sh"\
        ;;\
    *)\
        echo "\uc0\u9888 \u65039   Invalid input. Please enter y or n. Skipping launch."\
        ;;\
esac\
}