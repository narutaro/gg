validate_semantic_version() {
  local version="$1"
  local semver_regex="^([0-9]+)\.([0-9]+)\.([0-9]+)(-([0-9A-Za-z.-]+))?(\+([0-9A-Za-z.-]+))?$"
  [[ "$version" =~ $semver_regex ]] || echo $(log ERROR "Invalid semantic version: $version")
}