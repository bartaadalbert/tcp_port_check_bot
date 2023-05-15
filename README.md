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

To obtain your chat ID for a Telegram bot, you can follow these steps:

    Start a chat with your Telegram bot.
    Open a web browser and enter the following URL, replacing <YOUR_BOT_TOKEN> with your actual bot token:
    https://api.telegram.org/bot<YOUR_BOT_TOKEN>/getUpdates
Make sure your bot is already added as a member of the chat or has received a message from you before trying to retrieve the chat ID.

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


To access your local machine without relying on a public IP address from your ISP, you can set up a tunnel using a remote server with a public IP. This allows you to forward traffic from specific services on your local machine to the remote server, effectively accessing those services through the remote server.

Here's a general overview of the steps involved:

1. Obtain a remote server with a public IP address. You can rent a VPS (Virtual Private Server) from a cloud provider like AWS, DigitalOcean, or Linode.

2. Connect to the remote server using SSH. You can use the following command in your local terminal:

   ```
   ssh user@remote_server_ip
   ```

   Replace `user` with your username on the remote server and `remote_server_ip` with the IP address of the remote server.

3. Set up port forwarding to create a tunnel from your local machine to the remote server. Depending on the service you want to access, you can use different options:

   - For SSH access: Use the `-L` option to forward a local port to the remote server's SSH port. For example, to forward local port 2222 to the remote server's SSH port (usually 22), use the following command:

     ```
     ssh -L 2222:localhost:22 user@remote_server_ip
     ```

   - For VNC access: Use the `-L` option to forward a local port to the remote server's VNC port. For example, to forward local port 5901 to the remote server's VNC port (usually 5900), use the following command:

     ```
     ssh -L 5901:localhost:5900 user@remote_server_ip
     ```

   - For HTTP web service: Use the `-L` option to forward a local port to the remote server's HTTP port. For example, to forward local port 8080 to the remote server's HTTP port (usually 80), use the following command:

     ```
     ssh -L 8080:localhost:80 user@remote_server_ip
     ```

   Adjust the port numbers as per your requirements.

4. Once the SSH connection is established with port forwarding, you can access the service on your local machine by using `localhost` and the forwarded port. For example, for the SSH tunnel with local port 2222, you can SSH into your local machine using:

   ```
   ssh -p 2222 user@localhost
   ```

   Similarly, for other services, you can use the `localhost` and the corresponding forwarded port.

Remember to keep the SSH connection active for the tunnel to remain accessible. If the connection is interrupted, you may need to re-establish the SSH connection and set up the tunnel again.

This setup allows you to securely access your local machine's services through the remote server's public IP address. You can modify the tunnel configuration as needed for your specific use case.

That's it! You should now have the login notification script, port check script, and instructions for setting up tunnels on macOS and Ubuntu.

For more details and additional customization options, please refer to the individual script files and provided documentation.


