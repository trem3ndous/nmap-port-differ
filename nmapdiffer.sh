#!/bin/bash

### Config area ###
ip="ENTER_TARGET_IP"
discord_url="ENTER_DISCORD_WEBHOOK_URL"  # Leave empty if not using or use a different webhook it will probably works
##################

d=$(date +%Y-%m-%d)

# Check if the scan file exists
if [ ! -e "nmap_scan" ]; then
    # First scan, no previous file
    /usr/bin/nmap "$ip" | sed '1,4d; $d' > "nmap_scan"
else
    # Run new scan
    /usr/bin/nmap "$ip" | sed '1,4d; $d' > "new_nmap_scan"

    # Get diff output
    diff_output=$(/usr/bin/diff "nmap_scan" "new_nmap_scan")

    # Check if diff_output is non-empty
    if [ -n "$diff_output" ]; then
        echo "$d - Differences found:" >> "nmapdiff.log"
        echo "$diff_output" >> "nmapdiff.log"
    
        # Convert to valid JSON
        web_diff_output=$(printf '%s' "$diff_output" | jq -R -s '.')

        # Send to Discord if webhook URL is set
        if [ -n "$discord_url" ]; then
            generate_post_data() {
                cat <<EOF
{
  "content": $web_diff_output,
  "embeds": [{
    "title": "differ",
    "description": "nmapdiffer",
    "color": 45973
  }]
}
EOF
            }

            curl -H "Content-Type: application/json" -X POST -d "$(generate_post_data)" "$discord_url"
        fi
    fi

    # Replace old scan with new
    mv "new_nmap_scan" "nmap_scan"
fi
