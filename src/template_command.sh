#echo "# this file is located in 'src/component_templates_command.sh'"
#echo "# code for 'gg component templates' goes here"
#echo "# you can edit it freely and regenerate (it will not be overwritten)"
#inspect_args

# Get relative path of this command to locate template dir 
# $command_name is a variable in bashly.yaml
if ! command -v $command_name > /dev/null 2>&1; then
  log ERROR "$command_name is not in your PATH. Please add it to proceed." >&2
  exit 1
fi

list_template_dirs() {
  dir="${1:-.}" # Default to current directory if no argument is given
  find "$dir" -type d -mindepth 1 | while read -r candidate_dir; do
    if [[ -d "$candidate_dir/src" && -d "$candidate_dir/deployment" && -d "$candidate_dir/recipe" ]]; then
      echo "${candidate_dir#$dir/}"
    fi
  done | sort | yq -o yaml 'split(" ")'
}

TEMPLATE_DIR=$(dirname "$(which "$command_name")")/$template_dir_path
log DEBUG "Template dir - $TEMPLATE_DIR"

echo ""
list_template_dirs $TEMPLATE_DIR
echo ""