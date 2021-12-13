global_parse_day_and_lang() {
  while getopts "hd:l:" opt
  do
    case $opt in
      h) usage ;;
      d) DAY=$OPTARG ;;
      l) LANG=$OPTARG ;;
    esac
  done
  shift "$(( OPTIND - 1))"

  if [[ $DAY == 'infer' ]]; then
    DAY=$(date +'%d')
    MONTH=$(date +'%m')


    if (( 10#$MONTH == 12 )); then
      if (( 10#$DAY > 25 )); then
        echo "Specify the day: AOC has finished already."
        exit 1
      fi
    else
      echo "Specify the day: You are not in december. :)"
      exit 1
    fi
  fi

  if ! ([[ $DAY =~ [0-9]+ ]] && (( 1 <= 10#$DAY && 10#$DAY <= 25 ))); then
    exit_error "Invalid day. The day must be a number in the range [1,25]"
  fi

  DAY=$(printf '%02d' "$DAY")

  if [[ $LANG == 'infer' ]]; then

    TARGET_FILE=$({
      find day"$DAY" -type f -name "[Dd]ay$DAY.*" \
                     -not -path '*.cp_cache*' \
                     -printf '%T@ %p\n' \
        | sort -nr | head -1 \
        | grep . | cut -d' ' -f2- | xargs basename; } 2> /dev/null \
        || exit_error "No candidate file was found for day $DAY")

    TARGET_FILE="day${DAY}/$TARGET_FILE"

    LANG=${TARGET_FILE#*.}
  fi
}
