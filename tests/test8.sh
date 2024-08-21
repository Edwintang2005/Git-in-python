#!/bin/dash

# test8.sh tests the grip-checkout command.
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
2041 grip-checkout > "$expOutput" 2> "$expOutput"
expCode="$?"
cd ..

cd "$temp_dir" || exit 1
grip-checkout > "$impOutput" 2> "$impOutput"
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
touch a b c d
2041 grip-add 'a' 'b' 'c' > "$expOutput" 2> "$expOutput"
cd ..

cd "$temp_dir" || exit 1
grip-init > "$impOutput" 2> "$impOutput"
touch a b c d
grip-add 'a' 'b' 'c' > "$impOutput" 2> "$impOutput"
cd ..

# Testing ======================================================================

# Testing Can only be run after first commit
cd "$ref_dir" || exit 1
2041 grip-checkout -h > "$expOutput" 2> "$expOutput"
expCode="$?"
cd ..

cd "$temp_dir" || exit 1
grip-checkout -h > "$impOutput" 2> "$impOutput"
impCode="$?"
cd ..

testing="Can only be run after first commit"
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
2041 grip-commit -m 'hello' > "$expOutput" 2> "$expOutput"
cd ..

cd "$temp_dir" || exit 1
grip-commit -m 'hello' > "$impOutput" 2> "$impOutput"
cd ..

# Testing Usage
cd "$ref_dir" || exit 1
2041 grip-checkout > "$expOutput" 2> "$expOutput"
expCode="$?"
cd ..

cd "$temp_dir" || exit 1
grip-checkout > "$impOutput" 2> "$impOutput"
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

# Testing nonexistent branch
cd "$ref_dir" || exit 1
2041 grip-checkout 'a' > "$expOutput" 2> "$expOutput"
expCode="$?"
cd ..

cd "$temp_dir" || exit 1
grip-checkout 'a' > "$impOutput" 2> "$impOutput"
impCode="$?"
cd ..

testing="Checkout Nonexistent Branch"
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
2041 grip-branch 'hello' > "$expOutput" 2> "$expOutput"
cd ..

cd "$temp_dir" || exit 1
grip-branch 'hello' > "$impOutput" 2> "$impOutput"
cd ..

# Testing success
cd "$ref_dir" || exit 1
2041 grip-checkout 'hello' > "$expOutput" 2> "$expOutput"
expCode="$?"
cd ..

cd "$temp_dir" || exit 1
grip-checkout 'hello' > "$impOutput" 2> "$impOutput"
impCode="$?"
cd ..

testing="Checkout Success"
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

# Testing checkout current branch
cd "$ref_dir" || exit 1
2041 grip-checkout 'hello' > "$expOutput" 2> "$expOutput"
expCode="$?"
cd ..

cd "$temp_dir" || exit 1
grip-checkout 'hello' > "$impOutput" 2> "$impOutput"
impCode="$?"
cd ..

testing="Checkout Current Branch"
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
touch 'valid'
2041 grip-add 'valid' > "$expOutput" 2> "$expOutput"
cd ..

cd "$temp_dir" || exit 1
touch 'valid'
grip-add 'valid' > "$impOutput" 2> "$impOutput"
cd ..

# Testing checkout with changes
cd "$ref_dir" || exit 1
2041 grip-checkout 'trunk' > "$expOutput" 2> "$expOutput"
expCode="$?"
cd ..

cd "$temp_dir" || exit 1
grip-checkout 'trunk' > "$impOutput" 2> "$impOutput"
impCode="$?"
cd ..

testing="Checkout Unsaved Changes"
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