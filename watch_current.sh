#!/usr/bin/env bash

set -euo pipefail

source cp-utils/common.sh
source aoc-utils/common.sh

function usage ()
{
  echo <<EOF
Usage: $0

Watch changes to the files of the given day and run tests.
EOF
}

DAY=infer
LANG=infer

global_parse_day_and_lang "$@"

while true; do
  set +e
  find "day$DAY/" \
    | grep -v '.cp_cache' \
    | entr -drc ./aoc-utils/run_current.sh "$@"
  set -e
  sleep 0.5
done

