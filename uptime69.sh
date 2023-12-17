#!/bin/bash

now=$(date +"%d-%m-%Y_%H:%M:%S")
config_file="$(dirname "$0")/config/config.env"
services_file="$(dirname "$0")/config/services.txt"

if [ ! -f "$config_file" ]; then
  echo "[$now][ERR] config/config.env does not exist."
  exit 1
fi

source "$config_file"

if [ ! -f "$services_file" ]; then
  echo "[$now][ERR] config/services.txt does not exist."
  exit 1
fi

# Read the list of services
while read line; do
  # Skip commentented (starting with #) and empty lines
  if [[ $line == \#* ]] || [[ -z $line ]]; then
    continue
  fi

  now=$(date +"%d-%m-%Y_%H:%M:%S")

  # Parse the domain, port and optional string to search in the request output
  domain=$(echo $line | cut -d' ' -f1)
  port=$(echo $line | cut -d' ' -f2)
  search=$(echo $line | cut -d' ' -f3-)

  echo "[$now] Checking $domain port $port (for ${search:-'nc_only'})"

  # Check if we're online
  if ! nc -z -w 10 9.9.9.9 53 >/dev/null 2>&1; then
    echo "[$now] Offline."
    continue
  fi

  # Remove the path from the domain if it exists (for netcat)
  domain_clean=$domain
  if [[ "$domain" == */* ]]; then
    domain_clean=${domain%%/*}
  fi

  # Use netcat to check if the service is up
  if nc -z $domain_clean $port >/dev/null 2>&1; then
    # If the service is up, and the argument search is specified, do an HTTPS call to the target
    if [ ! -z "$search" ]; then
      response=$(curl -A "$USER_AGENT" -s -w "\n%{http_code}" "https://$domain")
      output=$(echo "$response" | head -n -1)
      http_code=$(echo "$response" | tail -n 1)

      # If the HTTPS call is successful, check if the search string is present in the output
      if [ "$http_code" -eq 200 ] && ! echo "$output" | grep -q "$search"; then
        # If not present, send an alert
        message="The text \"$search\" was not found in the output of https://$domain"
        curl -s -X POST https://api.telegram.org/bot$TELEGRAM_TOKEN/sendMessage -d chat_id=$CHAT_ID -d text="$message"
      elif [ "$http_code" -ne 200 ]; then
        # If the HTTPS call fails or returns an error status code, send an alert
        message="The HTTPS call to https://$domain failed with HTTP code $http_code"
        curl -s -X POST https://api.telegram.org/bot$TELEGRAM_TOKEN/sendMessage -d chat_id=$CHAT_ID -d text="$message"
      fi
    fi
  else
    # If the service is down, send an alert
    message="The service at $domain port $port is down!"
    curl -s -X POST https://api.telegram.org/bot$TELEGRAM_TOKEN/sendMessage -d chat_id=$CHAT_ID -d text="$message"
  fi
done < "$services_file"
