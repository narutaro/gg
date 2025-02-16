# echo "# this file is located in 'src/deployment_list_target_command.sh'"
# echo "# code for 'gg deployment list-target' goes here"
# echo "# you can edit it freely and regenerate (it will not be overwritten)"
# inspect_args

cmd=(
  aws greengrassv2 list-deployments --query
  deployments[].targetArn --output yaml
)
log DEBUG "Executing - ${cmd[*]}"

echo ""
"${cmd[@]}" | yq
#"${cmd[@]}" | yq eval '[.[] | split("/")[-1]]' -P
echo ""
