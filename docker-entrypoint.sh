#!/bin/bash

PATH=$PATH:/certspotter/bin
CS_DELAY=${CS_DELAY:-86400}
CMD="/certspotter/bin/certspotter -stdout"

RESULT=""

#script /certspotter/bin/notify.sh"

# shellcheck disable=SC1091
source /certspotter/utils.bash

if [ -n "${CS_DEBUG}" ]; then
  debug "Setting certspotter to verbose mode"
  CMD="$CMD -verbose"
fi

# Check mandatory ENV vars
if [ -z "${CS_DOMAINS}" ]; then
  error "CS_DOMAINS environment variable must be set"
  exit 1
fi

# Notify slack when debug mode is enable
if [ -n "${CS_DEBUG}" ]; then
  notify.sh "Certspotter starting for domains ${CS_DOMAINS}. Running every ${CS_DELAY} seconds."
fi

echo "${CS_DOMAINS}" | tr ' ;,' '\n' > /certspotter/.certspotter/watchlist

function check_certs() {
  info "Checking certs"
  ${CMD}
  info "Done checking certs"
}

while true; do
  check_certs
  sleep "${CS_DELAY}"
done

