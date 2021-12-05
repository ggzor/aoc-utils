#!/usr/bin/env bash

set -euo pipefail

source cp-utils/common.sh
source aoc-utils/common.sh

function usage ()
{
  echo <<EOF
Usage: $0 [-d DAY] [-l LANGUAGE]

Run the checks for the file of the given LANGUAGE
for DAY.

DAY defaults to today.
LANGUAGE defaults to the latest modified file of the given day.
EOF
  exit 1
}

DAY=infer
LANG=infer
TARGET_FILE=

global_parse_day_and_lang "$@"

if [[ ! -f "$TARGET_FILE" ]]; then
  exit_error "'$TARGET_FILE' doesn't exist"
fi

echo "Day: $DAY"
echo "Language: $LANG"
echo "File: $TARGET_FILE"
echo
./cp-utils/check.sh "$TARGET_FILE"

