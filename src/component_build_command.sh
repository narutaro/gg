# echo "# this file is located in 'src/component_build_command.sh'"
# echo "# code for 'gdc component build' goes here"
# echo "# you can edit it freely and regenerate (it will not be overwritten)"
# inspect_args
COMPONENT_VERSION=${args[component_version]}
COMPONENT_NAME=$(yq '.componentName' $config_file)
S3_BUCKET_NAME=$(yq '.s3BucketName' $config_file)

log DEBUG "Building component version - $COMPONENT_VERSION"

# Update component version in recipe.yaml
log DEBUG "Updating component version in the recipe.yaml - $COMPONENT_VERSION"
yq -i ".ComponentVersion =\"$COMPONENT_VERSION\"" $recipe_yaml_path

# Update S3 URI in recipe.yaml
S3_URI="s3://$S3_BUCKET_NAME/artifacts/$COMPONENT_NAME/$COMPONENT_VERSION/files.zip"
log DEBUG "Updating articact S3 URI in the recipe.yaml - $S3_URI"
yq -i ".Manifests[].Artifacts[].URI = \"$S3_URI\"" $recipe_yaml_path

# TODO - use this for the version replacement
# NEW_VERSION="8.1.0"
# yq -i '.Manifests[].Artifacts[].URI |= sub("[0-9]+\\.[0-9]+\\.[0-9]+", "'$NEW_VERSION'")' file.yml

# Place the artifacts
mkdir -p $artifacts_dir_path/$COMPONENT_NAME/$COMPONENT_VERSION
cp $src_dir_path/*.* $artifacts_dir_path/$COMPONENT_NAME/$COMPONENT_VERSION
cp $recipe_yaml_path $recipes_dir_path/recipe-$COMPONENT_VERSION.yaml
cd $artifacts_dir_path/$COMPONENT_NAME/$COMPONENT_VERSION && zip -rq files.zip * && cd - > /dev/null 

log INFO "$COMPONENT_NAME - $COMPONENT_VERSION built"