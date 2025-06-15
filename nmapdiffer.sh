#!/bin/bash

### Config area ###
ip="ENTER_YOUR_IP_HERE"
discord_url="YOUR_DISCORD_WEBHOOK_URL"  # Leave empty if not using or use a different webhook it will probably works
##################

d=$(date +%Y-%m-%d)

# Check if the scan file exists
if [ ! -e "nmapdiffer_scan.xml" ]; then
    # First scan, no previous file
    /usr/bin/nmap -sC -sV "$ip" -p- --open -oX "nmapdiffer_scan.xml" > /dev/null 2>&1
else
    # Run new scan
    /usr/bin/nmap -sC -sV "$ip" -p- --open -oX "new_nmapdiffer_scan.xml" > /dev/null 2>&1

    # Get diff output
    diff_output=$(/usr/bin/ndiff "nmapdiffer_scan.xml" "new_nmapdiffer_scan.xml")

    # Check if diff_output is non-empty
    if [ -n "$diff_output" ]; then
        echo "$d - Differences found:" >> "nmaptcpdiff.log"
        echo "$diff_output" >> "nmaptcpdiff.log"

        # Send to Discord if webhook URL is set
        if [ -n "$discord_url" ]; then
            curl -H "Content-Type: application/json" \
                 -X POST \
                 -d "{\"content\":\"Nmap scan differences detected for $ip on $d:\n$diff_output\"}" \
                 "$discord_url"
        fi
    fi

    # Replace old scan with new
    mv "new_nmapdiffer_scan.xml" "nmapdiffer_scan.xml"
fi
