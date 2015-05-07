#!/bin/bash

set -e -o pipefail

cd "$CURR_DIR"/describe-project

temp_file=`mktemp`

function cleanup {
    rm $temp_file
}

trap cleanup EXIT

if ! $DUB describe --compiler=$COMPILER \
    --data=package-target-type --data=recursive-target-type \
    --data=package-target-path --data=recursive-target-path \
    --data=package-target-name --data=recursive-target-name \
    --data=package-working-directory --data=recursive-working-directory \
    --data=package-main-source-file --data=recursive-main-source-file \
    --data=package-dflags --data=recursive-dflags \
    --data=package-lflags --data=recursive-lflags \
    --data=package-libs --data=recursive-libs \
    --data=package-source-files --data=recursive-source-files \
    --data=package-copy-files --data=recursive-copy-files \
    --data=package-versions --data=recursive-versions \
    --data=package-debug-versions --data=recursive-debug-versions \
    --data=package-import-paths --data=recursive-import-paths \
    --data=package-string-import-paths --data=recursive-string-import-paths \
    --data=package-import-files --data=recursive-import-files \
    --data=package-string-import-files --data=recursive-string-import-files \
    --data=package-pre-generate-commands --data=recursive-pre-generate-commands \
    --data=package-post-generate-commands --data=recursive-post-generate-commands \
    --data=package-pre-build-commands --data=recursive-pre-build-commands \
    --data=package-post-build-commands --data=recursive-post-build-commands \
    --data=package-requirements --data=recursive-requirements \
    --data=package-options --data=recursive-options \
    > "$temp_file"; then
    die 'Printing project data failed!'
fi

rm "$CURR_DIR/actual-output"
cp "$temp_file" "$CURR_DIR/actual-output"

# Create the expected output path file to compare against.
expected_file="$CURR_DIR/expected-describe-data-output"
# --data=*-target-type
echo "executable" > "$expected_file"
echo >> "$expected_file"
echo "executable" >> "$expected_file"
echo "sourceLibrary" >> "$expected_file"
echo "sourceLibrary" >> "$expected_file"
echo >> "$expected_file"
# --data=*-target-path
echo "$CURR_DIR/describe-project/" >> "$expected_file"
echo >> "$expected_file"
echo "$CURR_DIR/describe-project/" >> "$expected_file"
echo "$CURR_DIR/describe-dependency-1/" >> "$expected_file"
echo "$CURR_DIR/describe-dependency-2/" >> "$expected_file"
echo >> "$expected_file"
# --data=*-target-name
echo "describe-project" >> "$expected_file"
echo >> "$expected_file"
echo "describe-project" >> "$expected_file"
echo "describe-dependency-1" >> "$expected_file"
echo "describe-dependency-2" >> "$expected_file"
echo >> "$expected_file"
# --data=*-working-directory
echo "$CURR_DIR/describe-project/" >> "$expected_file"
echo >> "$expected_file"
echo "$CURR_DIR/describe-project/" >> "$expected_file"
echo "$CURR_DIR/describe-dependency-1/" >> "$expected_file"
echo "$CURR_DIR/describe-dependency-2/" >> "$expected_file"
echo >> "$expected_file"
# --data=*-main-source-file
echo "$CURR_DIR/describe-project/src/dummy.d" >> "$expected_file"
echo >> "$expected_file"
echo "$CURR_DIR/describe-project/src/dummy.d" >> "$expected_file"
echo >> "$expected_file"
# --data=*-dflags
echo "--some-dflag" >> "$expected_file"
echo >> "$expected_file"
echo "--some-dflag" >> "$expected_file"
echo "--another-dflag" >> "$expected_file"
echo >> "$expected_file"
# --data=*-lflags
echo "--some-lflag" >> "$expected_file"
echo >> "$expected_file"
echo "--some-lflag" >> "$expected_file"
echo "--another-lflag" >> "$expected_file"
echo >> "$expected_file"
# --data=*-libs
echo "ssl" >> "$expected_file"
echo >> "$expected_file"
echo "ssl" >> "$expected_file"
echo "curl" >> "$expected_file"
echo >> "$expected_file"
# --data=*-source-files
echo "$CURR_DIR/describe-project/src/dummy.d" >> "$expected_file"
echo >> "$expected_file"
echo "$CURR_DIR/describe-project/src/dummy.d" >> "$expected_file"
echo "$CURR_DIR/describe-dependency-1/source/dummy.d" >> "$expected_file"
echo >> "$expected_file"
# --data=*-copy-files
echo "$CURR_DIR/describe-project/data/dummy.dat" >> "$expected_file"
echo >> "$expected_file"
echo "$CURR_DIR/describe-project/data/dummy.dat" >> "$expected_file"
echo "$CURR_DIR/describe-dependency-1/data/*" >> "$expected_file"
echo >> "$expected_file"
# --data=*-versions
echo "someVerIdent" >> "$expected_file"
echo >> "$expected_file"
echo "someVerIdent" >> "$expected_file"
echo "anotherVerIdent" >> "$expected_file"
echo >> "$expected_file"
# --data=*-debug-versions
echo "someDebugVerIdent" >> "$expected_file"
echo >> "$expected_file"
echo "someDebugVerIdent" >> "$expected_file"
echo "anotherDebugVerIdent" >> "$expected_file"
echo >> "$expected_file"
# --data=*-import-paths
echo "$CURR_DIR/describe-project/src/" >> "$expected_file"
echo >> "$expected_file"
echo "$CURR_DIR/describe-project/src/" >> "$expected_file"
echo "$CURR_DIR/describe-dependency-1/source/" >> "$expected_file"
echo "$CURR_DIR/describe-dependency-2/some-path/" >> "$expected_file"
echo >> "$expected_file"
# --data=*-string-import-paths
echo "$CURR_DIR/describe-project/views/" >> "$expected_file"
echo >> "$expected_file"
echo "$CURR_DIR/describe-project/views/" >> "$expected_file"
echo "$CURR_DIR/describe-dependency-2/some-extra-string-import-path/" >> "$expected_file"
echo >> "$expected_file"
# --data=*-import-files
echo >> "$expected_file"
echo "$CURR_DIR/describe-dependency-2/some-path/dummy.d" >> "$expected_file"
echo >> "$expected_file"
# --data=*-string-import-files
echo "$CURR_DIR/describe-project/views/dummy.d" >> "$expected_file"
echo >> "$expected_file"
echo "$CURR_DIR/describe-project/views/dummy.d" >> "$expected_file"
echo "$CURR_DIR/describe-dependency-2/some-extra-string-import-path/dummy.d" >> "$expected_file"
echo >> "$expected_file"
# --data=*-pre-generate-commands
echo "./do-preGenerateCommands" >> "$expected_file"
echo >> "$expected_file"
echo "./do-preGenerateCommands" >> "$expected_file"
echo "./dependency-preGenerateCommands" >> "$expected_file"
echo >> "$expected_file"
# --data=*-post-generate-commands
echo "./do-postGenerateCommands" >> "$expected_file"
echo >> "$expected_file"
echo "./do-postGenerateCommands" >> "$expected_file"
echo "./dependency-postGenerateCommands" >> "$expected_file"
echo >> "$expected_file"
# --data=*-pre-build-commands
echo "./do-preBuildCommands" >> "$expected_file"
echo >> "$expected_file"
echo "./do-preBuildCommands" >> "$expected_file"
echo "./dependency-preBuildCommands" >> "$expected_file"
echo >> "$expected_file"
# --data=*-post-build-commands
echo "./do-postBuildCommands" >> "$expected_file"
echo >> "$expected_file"
echo "./do-postBuildCommands" >> "$expected_file"
echo "./dependency-postBuildCommands" >> "$expected_file"
echo >> "$expected_file"
# --data=*-requirements
echo "disallowInlining" >> "$expected_file"
echo >> "$expected_file"
echo "disallowInlining" >> "$expected_file"
echo "requireContracts" >> "$expected_file"
echo "none" >> "$expected_file"
echo >> "$expected_file"
# --data=*-options
echo "releaseMode" >> "$expected_file"
echo "debugInfo" >> "$expected_file"
echo >> "$expected_file"
echo "releaseMode" >> "$expected_file"
echo "debugInfo" >> "$expected_file"
echo "stackStomping" >> "$expected_file"
echo "none" >> "$expected_file"

if ! diff "$expected_file" "$temp_file"; then
    die 'The project data did not match the expected output!'
fi

