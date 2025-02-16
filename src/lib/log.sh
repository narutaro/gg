log() {
  local level=$1
  shift
  local message="$*"

  local level_priority=0  
  local min_priority=0

  # level_priority
  case "$level" in
    DEBUG)  level_priority=1 ;;
    INFO)   level_priority=2 ;;
    WARN)   level_priority=3 ;;
    ERROR)  level_priority=4 ;;
    *) 
      echo "Invalid log level: $level"
      return 1
      ;;
  esac

  # min_priority
  case "$MESSAGE_LEVEL" in
    DEBUG)  min_priority=1 ;;
    INFO)   min_priority=2 ;;
    WARN)   min_priority=3 ;;
    ERROR)  min_priority=4 ;;
    *) 
      echo "Invalid LOG_LEVEL: $MESSAGE_LEVEL"
      return 1 
      ;;
  esac

  local timestamp=$(date '+%Y-%m-%dT%H:%M:%S%z')

  # Compare level_priority with min_priority
  if [ "$level_priority" -ge "$min_priority" ]; then
    echo "$timestamp [$level] $message"
  fi
}