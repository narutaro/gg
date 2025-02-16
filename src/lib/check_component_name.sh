check_component_name() {
  component_name="$1"
  # Component name is used for S3 bucket name. Check S3 bucket name requirements.

  # Check the length of the bucket name
  if [ ${#component_name} -lt 3 ] || [ ${#component_name} -gt 63 ]; then
    # TODO - include prefix for a component name
    log ERROR "The component name must be between 3 and 63 characters long."
    return 1
  fi

  # Check if the component name only contains lowercase letters, numbers, and dashes
  if [[ ! "$component_name" =~ ^[a-z0-9-]+$ ]]; then
    log ERROR "The component name can only contain lowercase letters, numbers, and dashes."
    return 1
  fi

  # Check if the component name starts or ends with a dash
  if [[ "$component_name" == -* ]] || [[ "$component_name" == *- ]]; then
    log ERROR "The component name cannot start or end with a dash."
    return 1
  fi

  # Check if the component name is in an IP address format (only digits and dots)
  if [[ "$component_name" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    log ERROR "The component name cannot be an IP address."
    return 1
  fi
}