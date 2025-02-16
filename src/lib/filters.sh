filter_is_project_root(){
  required_items=("component" "deployment" "config.yaml")
  missing_items=()

  for item in "${required_items[@]}"; do
    if [ ! -e "$item" ]; then
      missing_items+=("$item")
    fi
  done

  if [ ${#missing_items[@]} -gt 0 ]; then
    echo $(log ERROR "Run this command in the project root dir.")
  fi
}

filter_deployment_yaml_exists(){
  if [ ! -e "$deployment_yaml_path" ]; then
    echo $(log ERROR "deployment.yaml is missing. Have you done deployment init or pull?")
  fi
}