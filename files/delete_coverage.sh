#!/bin/bash

# Check if COVERAGEID is provided as an argument
if [ -z "$1" ]; then
  echo "Usage: $0 <COVERAGEID>"
  exit 1
fi

COVERAGEID="$1"

# Load the environment variables from /etc/default/rasdaman
. /etc/default/rasdaman

# Run the curl command with the provided COVERAGEID
response=$(curl --user "$RASCURL" --insecure -s -o /dev/null -w "%{http_code}" "https://localhost/rasdaman/ows?SERVICE=WCS&VERSION=2.0.1&REQUEST=DeleteCoverage&COVERAGEID=${COVERAGEID}")

# Check the response code and print the appropriate message
if [ "$response" -eq 200 ]; then
  echo "Coverage ID ${COVERAGEID} has been deleted."
else
  echo "Could not delete Coverage ID ${COVERAGEID}. Response code: $response"
fi