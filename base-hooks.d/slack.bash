#!/bin/bash

# shellcheck disable=SC1091
source /certspotter/utils.bash

if [ -n "${1}" ]; then
	SUMMARY=$1
fi

if [ -n "${SUMMARY}" ] && [ -n "${CS_SLACK_URL}" ]; then
  curl -X POST --silent --data-urlencode "payload={\"text\": \"$SUMMARY\"}" "$CS_SLACK_URL";
fi

