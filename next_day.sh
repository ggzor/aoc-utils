#!/usr/bin/env bash

set -euo pipefail

source cp-utils/common.sh

if (( $# == 0 )); then
  cat <<EOF
Usage: $0 LANGUAGES...

Setup the next AOC day with the given language templates
EOF
  exit 1
fi

DAY=$(find -type d -name 'day??' \
        | sort -rV | head -1 \
        | grep -oP 'day\K\d+' \
        || echo '01')

DAY=$(printf '%02d' "$(( 10#$DAY + 1 ))")
DAY_DIR="day$DAY"

delete_dir() {
  EXIT_STATUS=$?
  if (( $EXIT_STATUS != 0 )); then
    rm -rf "$DAY_DIR"
  fi
  exit "$EXIT_STATUS"
}
delete_force() {
  exit 1
  delete_dir
}

trap delete_dir EXIT
trap delete_force SIGINT

if (( $DAY > 25 )); then
  echo "No more days to go. :)"
  exit 1
fi

echo "Setting up $DAY_DIR..."
mkdir "$DAY_DIR"

./cp-utils/copy-template.sh "$DAY_DIR" "$@"

TEST_FILE=${DAY_DIR}/test.txt
INPUT_FILE=${DAY_DIR}/input.txt

read -p "Press enter to paste the clipboard contents to ${TEST_FILE}..."
xclip -o > "$TEST_FILE"

read -p "Which output do we expect?: " EXPECTED
{
  cat <<EOF
# Part one
check test.txt  1 <<< $EXPECTED
_check input.txt 1 <<< 0

# Part two
# check test.txt  2 <<< 0
# _check input.txt 2 <<< 0
EOF
} > "$DAY_DIR/spec.sh"

if [[ -n "$COOKIE" ]]; then
  echo "Downloading input to $DAY_DIR..."

  curl -sfL --cookie "$COOKIE" \
    "https://adventofcode.com/2021/day/$(( 10#$DAY + 0 ))/input" \
    > "$INPUT_FILE"
else
  echo "Skipping input download, no \$COOKIE was set."
fi

