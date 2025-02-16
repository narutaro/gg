get_thing_type() {
  local name="$1"

  local is_thing
  is_thing=$(aws iot describe-thing --thing-name "$name" --query 'thingName' --output text 2>/dev/null)

  local is_group
  is_group=$(aws iot describe-thing-group --thing-group-name "$name" --query 'thingGroupName' --output text 2>/dev/null)

  if [ -n "$is_thing" ] && [ -n "$is_group" ]; then
    log ERROR "Found the name '$name' both in Thing and ThingGroup. Please use a different target name." >&2
    exit 1
  elif [ -n "$is_thing" ]; then
    echo "thing"
  elif [ -n "$is_group" ]; then
    echo "thinggroup"
  else
    log ERROR "The name '$name' does not belong to a Thing or a ThingGroup." >&2
    exit 1
  fi
}