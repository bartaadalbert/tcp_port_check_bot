#!/bin/bash

# Define the ports to check
PORTS=(8000 22)

# Define the corresponding port names
PORT_NAMES=("HOME HTTP" "HOME SSH")

# Telegram configuration
TELEGRAM_TOKEN="TELEGRAM_TOKEN"
CHAT_ID="-0000000id"

# Get the server hostname
HOSTNAME=$(hostname)

# Perform the port checks
for i in "${!PORTS[@]}"; do
    PORT="${PORTS[i]}"
    PORT_NAME="${PORT_NAMES[i]}"

    # Path to the file for checking messaging
    FILE_UP_DOWN="$PWD/up_down_$PORT.txt"

    # Check if the up_down file exists, create it if not
    if [[ ! -e $FILE_UP_DOWN ]]; then
        touch $FILE_UP_DOWN
    fi

    # Read the saved line from the file
    LINE_SAVED=$(<"$FILE_UP_DOWN")

    # Perform the port check
    var=$(lsof -i :$PORT) > /dev/null 2>&1
    if [[ ! -z "$var" || $(echo "$var" | grep "CLOSE_WAIT") ]]; then
        LINE=1
        RESULT="***** UP *****"
    else
        LINE=0
        RESULT="----- DOWN, ALERT -----"
    fi

    # Compare the current and saved lines
    if [[ -z $LINE_SAVED ]] || ((LINE != LINE_SAVED)); then
        # Update the saved line in the file
        echo "$LINE" > "$FILE_UP_DOWN"

        # Send notification using wget
        MESSAGE="Server: $HOSTNAME Port: $PORT_NAME ($PORT) $RESULT"
        # curl -s "https://api.telegram.org/bot$TELEGRAM_TOKEN/sendMessage" -d "chat_id=$CHAT_ID" -d "text=$MESSAGE" -d "parse_mode=HTML" > /dev/null
        wget -qO- "https://api.telegram.org/bot$TELEGRAM_TOKEN/sendMessage?chat_id=$CHAT_ID&parse_mode=html&disable_web_page_preview=true&text=$MESSAGE" > /dev/null 2>&1
    fi
done
