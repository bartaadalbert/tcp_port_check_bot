# tcp_port_check_bot
# Telegram Bot and Tunnel Setup, with port monitoring and server login check

This project provides scripts and instructions for various functionalities, including login notifications, port checks, and tunnel setups.

## Login Notification Script

The login notification script sends a notification to a Telegram bot when a user logs into the server. To set up the script, follow these steps:

1. Install the `jq` package: `sudo apt install jq`.
2. Create the script file `/etc/ssh/login-notify.sh` with the provided content.
3. Make the script file executable: `sudo chmod +x /etc/ssh/login-notify.sh`.
4. Edit the `/etc/pam.d/sshd` file and add the following line after `@include ... session ...`:
    @include common-password
    session optional pam_exec.so /etc/ssh/login-notify.sh

5. Set the `TELEGRAM_TOKEN` and `CHAT_ID` environment variables in the script with your Telegram bot token and chat ID.
6. Optionally, customize the message content as per your requirements.
7. Save the changes and restart the SSH service.

## Port Check Script

The port check script allows you to monitor the status of specific ports and sends a notification to a Telegram bot when a port goes up or down. To use the script, follow these steps:

1. Define the ports to check and their corresponding names in the script.
2. Set the `TELEGRAM_TOKEN` and `CHAT_ID` environment variables in the script with your Telegram bot token and chat ID.
3. Save the changes and make the script executable if necessary.
4. Optionally, customize the notification message content.
5. Run the script to start monitoring the ports.

## Tunnel Setup - Local to Remote

To set up a tunnel from your local machine to a remote server, follow these steps:

### macOS

1. Create a new plist file using the provided template.
2. Replace the placeholders in the plist file with your specific values, including the local and remote ports, server hostname, and SSH connection details.
3. Save the plist file.
4. Move the plist file to the `~/Library/LaunchAgents` directory.
5. Run the command `launchctl load ~/Library/LaunchAgents/<plist-filename>.plist` to load the launch agent.
6. The tunnel will be automatically established and maintained.

### Ubuntu

1. Create a new service file using the provided template.
2. Replace the placeholders in the service file with your specific values, including the local and remote ports, server hostname, and SSH connection details.
3. Save the service file.
4. Move the service file to the `/etc/systemd/system` directory.
5. Run the command `sudo systemctl daemon-reload` to reload the systemd daemon.
6. Start the service using the command `sudo systemctl start <service-name>`.
7. Enable the service to start on boot using the command `sudo systemctl enable <service-name>`.

That's it! You should now have the login notification script, port check script, and instructions for setting up tunnels on macOS and Ubuntu.

For more details and additional customization options, please refer to the individual script files and provided documentation.

