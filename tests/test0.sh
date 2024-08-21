#!/bin/dash

# test0.sh tests the grip-init command.
# Edwin Tang (z5482091)
# Initialisation ===============================================================
PATH="$PATH:$(pwd)"

# making a temp directory 
test_dir="$(mktemp -d)"
cd "$test_dir" || exit 1 

ref_dir="$(mktemp -d)"
temp_dir="$(mktemp -d)"

TMPFILE=$(mktemp) # USED FOR TEST FILE DEVIANTS
expOutput=$(mktemp) # USED FOR SAMPLE OUTPUT
impOutput=$(mktemp) # USED FOR IMPLEMENTATION OUTPUT
diffOutput=$(mktemp) # UNSED FOR DIFF OUTPUT
trap 'rm -f $TMPFILE $$expOutput $$impOutput $$diffOutput -rf "$test_dir" -rf "ref_dir" -rf "temp_dir"' EXIT

PASSED='\033[1;32mPassed\033[0m'
FAILED='\033[1;31mFailed\033[0m'

# Testing ======================================================================

# Testing Usage
cd "$ref_dir" || exit 1
2041 grip-init 'argument' > "$expOutput" 2> "$expOutput"
expCode="$?"
cd ..

cd "$temp_dir" || exit 1
grip-init 'argument' > "$impOutput" 2> "$impOutput"
impCode="$?"
cd ..

testing="Usage"
diff "$expOutput" "$impOutput" > "$diffOutput"
if [ -s $diffOutput ]
then
    echo "Test for $testing $FAILED."
    echo "Mismatch in output:"
    echo "=======PRINTED======="
    cat "$impOutput"
    echo "=======SAMPLED======="
    cat "$expOutput"
    echo "====================="
elif [ "$expCode" -ne "$impCode" ]
then
    echo "Test for $testing $FAILED."
    echo "Expected exit code: $expCode, Implementation exit code: $impCode"
else
    echo "Test for $testing $PASSED."
fi

# Testing Success
cd "$ref_dir" || exit 1
2041 grip-init > "$expOutput" 2> "$expOutput"
expCode="$?"
cd ..

cd "$temp_dir" || exit 1
grip-init > "$impOutput" 2> "$impOutput"
impCode="$?"
cd ..

testing="Grip-init - Success"
diff "$expOutput" "$impOutput" > "$diffOutput"
if [ -s $diffOutput ]
then
    echo "Test for $testing $FAILED."
    echo "Mismatch in output:"
    echo "=======PRINTED======="
    cat "$impOutput"
    echo "=======SAMPLED======="
    cat "$expOutput"
    echo "====================="
elif [ "$expCode" -ne "$impCode" ]
then
    echo "Test for $testing $FAILED."
    echo "Expected exit code: $expCode, Implementation exit code: $impCode"
else
    echo "Test for $testing $PASSED."
fi

# Testing Failure
cd "$ref_dir" || exit 1
2041 grip-init > "$expOutput" 2> "$expOutput"
expCode="$?"
cd ..

cd "$temp_dir" || exit 1
grip-init > "$impOutput" 2> "$impOutput"
impCode="$?"
cd ..

testing="Grip-init - Failure"
diff "$expOutput" "$impOutput" > "$diffOutput"
if [ -s $diffOutput ]
then
    echo "Test for $testing $FAILED."
    echo "Mismatch in output:"
    echo "=======PRINTED======="
    cat "$impOutput"
    echo "=======SAMPLED======="
    cat "$expOutput"
    echo "====================="
elif [ "$expCode" -ne "$impCode" ]
then
    echo "Test for $testing $FAILED."
    echo "Expected exit code: $expCode, Implementation exit code: $impCode"
else
    echo "Test for $testing $PASSED."
fi