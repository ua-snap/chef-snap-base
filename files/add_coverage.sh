#!/bin/bash

# Check if <PATH_TO_INGEST_DOC> is provided as an argument
if [ -z "$1" ]; then
  echo "Usage: $0 <PATH_TO_INGEST_DOC>"
  exit 1
fi

PATH_TO_INGEST_DOC="$1"

# Load the environment variables from /etc/default/rasdaman
. /etc/default/rasdaman

/opt/rasdaman/bin/wcst_import.sh -c 0 ${PATH_TO_INGEST_DOC}