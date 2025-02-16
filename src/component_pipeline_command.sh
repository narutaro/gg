# echo "# this file is located in 'src/component_pipeline_command.sh'"
# echo "# code for 'gg component pipeline' goes here"
# echo "# you can edit it freely and regenerate (it will not be overwritten)"
# inspect_args
COMPONENT_VERSION=${args[component_version]}

log INFO "Running the build, push and create pipeline for $COMPONENT_VERSION"
log INFO "Running component build"
build=($0 component build $COMPONENT_VERSION); ${build[@]}
log INFO "Running component push"
push=($0 component push $COMPONENT_VERSION); ${push[@]}
log INFO "Running component create"
create=($0 component create $COMPONENT_VERSION); ${create[@]}


