#!/bin/dash

# test1.sh tests the grip-add command.
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

# Testing No grip
cd "$ref_dir" || exit 1
2041 grip-add > "$expOutput" 2> "$expOutput"
expCode="$?"
cd ..

cd "$temp_dir" || exit 1
grip-add > "$impOutput" 2> "$impOutput"
impCode="$?"
cd ..

testing="No grip"
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

# Initialisation ===============================================================

cd "$ref_dir" || exit 1
2041 grip-init > "$expOutput" 2> "$expOutput"
expCode="$?"
cd ..

cd "$temp_dir" || exit 1
grip-init > "$impOutput" 2> "$impOutput"
impCode="$?"
cd ..

# Testing ======================================================================

# Testing Usage
cd "$ref_dir" || exit 1
2041 grip-add > "$expOutput" 2> "$expOutput"
expCode="$?"
cd ..

cd "$temp_dir" || exit 1
grip-add > "$impOutput" 2> "$impOutput"
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

# Testing Invalid filename
cd "$ref_dir" || exit 1
2041 grip-add '@ASD'> "$expOutput" 2> "$expOutput"
expCode="$?"
cd ..

cd "$temp_dir" || exit 1
grip-add '@ASD'> "$impOutput" 2> "$impOutput"
impCode="$?"
cd ..

testing="Invalid Filename"
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

# Testing File doesn't exist
cd "$ref_dir" || exit 1
2041 grip-add 'a'> "$expOutput" 2> "$expOutput"
expCode="$?"
cd ..

cd "$temp_dir" || exit 1
grip-add 'a'> "$impOutput" 2> "$impOutput"
impCode="$?"
cd ..

testing="File doesn't exist"
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

cd "$ref_dir" || exit 1
mkdir 'testDir'
cd ..

cd "$temp_dir" || exit 1
mkdir 'testDir'
cd ..

# Testing File is a directory
cd "$ref_dir" || exit 1
2041 grip-add 'testDir'> "$expOutput" 2> "$expOutput"
expCode="$?"
cd ..

cd "$temp_dir" || exit 1
grip-add 'testDir'> "$impOutput" 2> "$impOutput"
impCode="$?"
cd ..

testing="File is a directory"
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

cd "$ref_dir" || exit 1
touch 'a'
touch 'b'
cd ..

cd "$temp_dir" || exit 1
touch 'a'
touch 'b'
cd ..

# Testing Success
cd "$ref_dir" || exit 1
2041 grip-add 'a'> "$expOutput" 2> "$expOutput"
expCode="$?"
cd ..

cd "$temp_dir" || exit 1
grip-add 'a'> "$impOutput" 2> "$impOutput"
impCode="$?"
cd ..

testing="Success"
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

# Testing Success - multiple files
cd "$ref_dir" || exit 1
2041 grip-add 'a' 'b' > "$expOutput" 2> "$expOutput"
expCode="$?"
cd ..

cd "$temp_dir" || exit 1
grip-add 'a' 'b' > "$impOutput" 2> "$impOutput"
impCode="$?"
cd ..

testing="Success - Multiple Files"
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

# Testing Faliure with multiple files
cd "$ref_dir" || exit 1
2041 grip-add 'a' 'b' 'c'> "$expOutput" 2> "$expOutput"
expCode="$?"
cd ..

cd "$temp_dir" || exit 1
grip-add 'a' 'b' 'c'> "$impOutput" 2> "$impOutput"
impCode="$?"
cd ..

testing="Faliure with multiple files"
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

cd "$ref_dir" || exit 1
2041 grip-status > "$expOutput" 2> "$expOutput"
expCode="$?"
cd ..

cd "$temp_dir" || exit 1
grip-status > "$impOutput" 2> "$impOutput"
impCode="$?"
cd ..

testing="Faliure with multiple files - Verification"
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