#!/bin/bash

# shellcheck disable=SC1091
source /certspotter/utils.bash

if [ -n "${1}" ] && [ -n "${CS_PUSHOVER_TOKEN}" ] && [ -n "${CS_PUSHOVER_USER}" ]; then

  # From https://github.com/akusei/pushover-bash/blob/main/pushover.sh
  curl -X POST --silent \
    -H "Content-Type: application/json" \
    -d "{\"token\":\"${CS_PUSHOVER_TOKEN}\",\"user\":\"${CS_PUSHOVER_USER}\",\"message\":\"$1\"}" \
    "https://api.pushover.net/1/messages.json"

fi
