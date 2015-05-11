#!/bin/bash

set -e -o pipefail

cd "$CURR_DIR"/describe-project

temp_file=`mktemp`

function cleanup {
    rm $temp_file
}

trap cleanup EXIT

if ! $DUB describe --compiler=$COMPILER \
    --data=target-type \
    --data=target-path \
    --data=target-name \
    --data=working-directory \
    --data=main-source-file \
    --data=dflags \
    --data=lflags \
    --data=libs \
    --data=source-files \
    --data=copy-files \
    --data=versions \
    --data=debug-versions \
    --data=import-paths \
    --data=string-import-paths \
    --data=import-files \
    --data=string-import-files \
    --data=pre-generate-commands \
    --data=post-generate-commands \
    --data=pre-build-commands \
    --data=post-build-commands \
    --data=requirements \
    --data=options \
    > "$temp_file"; then
    die 'Printing project data failed!'
fi

rm "$CURR_DIR/actual-output"
cp "$temp_file" "$CURR_DIR/actual-output"

# Create the expected output path file to compare against.
expected_file="$CURR_DIR/expected-describe-data-output"
# --data=target-type
echo "executable" > "$expected_file"
echo >> "$expected_file"
# --data=target-path
echo "$CURR_DIR/describe-project/" >> "$expected_file"
echo >> "$expected_file"
# --data=target-name
echo "describe-project" >> "$expected_file"
echo >> "$expected_file"
# --data=working-directory
echo "$CURR_DIR/describe-project/" >> "$expected_file"
echo >> "$expected_file"
# --data=main-source-file
echo "$CURR_DIR/describe-project/src/dummy.d" >> "$expected_file"
echo >> "$expected_file"
# --data=dflags
echo "--some-dflag" >> "$expected_file"
echo "--another-dflag" >> "$expected_file"
echo >> "$expected_file"
# --data=lflags
echo "--some-lflag" >> "$expected_file"
echo "--another-lflag" >> "$expected_file"
echo >> "$expected_file"
# --data=libs
echo "ssl" >> "$expected_file"
echo "curl" >> "$expected_file"
#echo "$CURR_DIR/describe-dependency-3/libdescribe-dependency-3" >> "$expected_file" # TODO: Currently fails. Don't know why.
echo >> "$expected_file"
# --data=source-files
echo "$CURR_DIR/describe-project/src/dummy.d" >> "$expected_file"
echo >> "$expected_file"
# --data=copy-files
echo "$CURR_DIR/describe-project/data/dummy.dat" >> "$expected_file"
echo "$CURR_DIR/describe-dependency-1/data/*" >> "$expected_file"
echo >> "$expected_file"
# --data=versions
echo "Have_describe_project" >> "$expected_file"
echo "someVerIdent" >> "$expected_file"
echo "Have_describe_dependency_1" >> "$expected_file"
echo "anotherVerIdent" >> "$expected_file"
echo "Have_describe_dependency_2" >> "$expected_file"
echo "Have_describe_dependency_3" >> "$expected_file"
echo >> "$expected_file"
# --data=debug-versions
echo "someDebugVerIdent" >> "$expected_file"
echo "anotherDebugVerIdent" >> "$expected_file"
echo >> "$expected_file"
# --data=import-paths
echo "$CURR_DIR/describe-project/src/" >> "$expected_file"
echo "$CURR_DIR/describe-dependency-1/source/" >> "$expected_file"
echo "$CURR_DIR/describe-dependency-2/some-path/" >> "$expected_file"
echo "$CURR_DIR/describe-dependency-3/dep3-source/" >> "$expected_file"
echo >> "$expected_file"
# --data=string-import-paths
echo "$CURR_DIR/describe-project/views/" >> "$expected_file"
echo "$CURR_DIR/describe-dependency-2/some-extra-string-import-path/" >> "$expected_file"
echo "$CURR_DIR/describe-dependency-3/dep3-string-import-path/" >> "$expected_file"
echo >> "$expected_file"
# --data=import-files
echo "$CURR_DIR/describe-dependency-2/some-path/dummy.d" >> "$expected_file"
echo >> "$expected_file"
# --data=string-import-files
echo "$CURR_DIR/describe-project/views/dummy.d" >> "$expected_file"
#echo "$CURR_DIR/describe-dependency-2/some-extra-string-import-path/dummy.d" >> "$expected_file" # This is missing from result, is that a bug?
echo >> "$expected_file"
# --data=pre-generate-commands
echo "./do-preGenerateCommands" >> "$expected_file"
echo "./dependency-preGenerateCommands" >> "$expected_file"
echo >> "$expected_file"
# --data=post-generate-commands
echo "./do-postGenerateCommands" >> "$expected_file"
echo "./dependency-postGenerateCommands" >> "$expected_file"
echo >> "$expected_file"
# --data=pre-build-commands
echo "./do-preBuildCommands" >> "$expected_file"
echo "./dependency-preBuildCommands" >> "$expected_file"
echo >> "$expected_file"
# --data=post-build-commands
echo "./do-postBuildCommands" >> "$expected_file"
echo "./dependency-postBuildCommands" >> "$expected_file"
echo >> "$expected_file"
# --data=requirements
echo "disallowInlining" >> "$expected_file"
echo "requireContracts" >> "$expected_file"
echo >> "$expected_file"
# --data=options
echo "releaseMode" >> "$expected_file"
echo "debugInfo" >> "$expected_file"
echo "stackStomping" >> "$expected_file"

if ! diff "$expected_file" "$temp_file"; then
    die 'The project data did not match the expected output!'
fi

