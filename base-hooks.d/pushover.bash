#!/bin/bash

# shellcheck disable=SC1091
source /certspotter/utils.bash

if [ -n "${1}" ]; then
	SUMMARY=$1
fi

if [ -n "${TEXT_FILENAME}" ]; then
	TEXT=$(<${TEXT_FILENAME})
	SUMMARY="${SUMMARY}
${TEXT}"
fi

if [ -n "${SUMMARY}" ] && [ -n "${CS_PUSHOVER_TOKEN}" ] && [ -n "${CS_PUSHOVER_USER}" ]; then

  # From https://github.com/akusei/pushover-bash/blob/main/pushover.sh
  curl -X POST --silent \
    -H "Content-Type: application/json" \
    -d "{\"token\":\"${CS_PUSHOVER_TOKEN}\",\"user\":\"${CS_PUSHOVER_USER}\",\"message\":\"$SUMMARY\"}" \
    "https://api.pushover.net/1/messages.json"

fi
