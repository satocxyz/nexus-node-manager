{\rtf1\ansi\ansicpg1252\cocoartf2822
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fswiss\fcharset0 Helvetica;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
\paperw11900\paperh16840\margl1440\margr1440\vieww11520\viewh8400\viewkind0
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0

\f0\fs24 \cf0 #!/bin/bash\
\
# Name of the screen session\
SCREEN_NAME="nexus_dashboard"\
\
# Start the dashboard in a detached screen\
echo "\uc0\u55357 \u56960  Launching Nexus Dashboard in screen session: $SCREEN_NAME"\
screen -dmS "$SCREEN_NAME" bash -c './nexus_updater.sh'\
\
# Small delay to ensure screen is created\
sleep 1\
\
# Show only screens related to nexus_*\
echo ""\
echo "\uc0\u55357 \u56741 \u65039   Active Nexus screen sessions:"\
screen -ls | grep -oE '\\t[0-9]+\\.(nexus_[^\\s]+)' | sed 's/^\\t//'\
\
echo ""\
echo "\uc0\u9989  Dashboard is running in screen session: $SCREEN_NAME"\
echo ""\
echo "\uc0\u55357 \u56589  To attach to the dashboard:"\
echo "   screen -r $SCREEN_NAME"\
echo ""\
echo "\uc0\u11013 \u65039   To detach and leave it running:"\
echo "   Press Ctrl + A, then D"\
echo ""\
}