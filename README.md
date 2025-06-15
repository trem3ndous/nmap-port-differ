# Nmap Port Differ
![image](https://github.com/user-attachments/assets/1f7668cf-f22b-4e5d-affc-ee5d99ee3684)

The flag grey line means the message was sent with >, meaining ports added. Messages with < mean that the port is down. 

Simple nmap differ script, compares open ports using `diff`, and optionally sends alerts to Discord if any changes are detected.

## Setup

1. **Edit the script** and replace:
   - `ip="ENTER_YOUR_IP_HERE"` with your target IP
   - `discord_url="YOUR_DISCORD_WEBHOOK_URL"` with your actual Discord webhook URL.

2. **Get a Discord webhook**:
   - Go to your Discord server → Channel Settings → Integrations → Webhooks → Create Webhook → Copy URL.

3. **Create daily cronjob**  
   Open your crontab:
   ```bash
   crontab -e
   ```
   Add the following line to run the script every day at 8 AM:
   ```bash
   
   0 8 * * * /full/path/to/nmapdiffer.sh
   ```
   Make sure the script is executable:
   ```bash
   chmod +x /full/path/to/nmapdiffer.sh
   ```
