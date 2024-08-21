#!/bin/dash

# test6.sh tests the grip-status command.
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
2041 grip-status > "$expOutput" 2> "$expOutput"
expCode="$?"
cd ..

cd "$temp_dir" || exit 1
grip-status > "$impOutput" 2> "$impOutput"
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

# Testing Usage
cd "$ref_dir" || exit 1
2041 grip-status -h > "$expOutput" 2> "$expOutput"
expCode="$?"
cd ..

cd "$temp_dir" || exit 1
grip-status -h > "$impOutput" 2> "$impOutput"
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

# Testing Successful status, all untracked
cd "$ref_dir" || exit 1
2041 grip-status > "$expOutput" 2> "$expOutput"
expCode="$?"
cd ..

cd "$temp_dir" || exit 1
grip-status > "$impOutput" 2> "$impOutput"
impCode="$?"
cd ..

testing="Successful Status"
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
2041 grip-add 'a' 'b' 'c' > "$expOutput" 2> "$expOutput"
cd ..

cd "$temp_dir" || exit 1
grip-add 'a' 'b' 'c' > "$impOutput" 2> "$impOutput"
cd ..

# Testing Successful status, some files added
cd "$ref_dir" || exit 1
2041 grip-status > "$expOutput" 2> "$expOutput"
expCode="$?"
cd ..

cd "$temp_dir" || exit 1
grip-status > "$impOutput" 2> "$impOutput"
impCode="$?"
cd ..

testing="Successful Status - files added"
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
2041 grip-commit -m 'insanity' > "$expOutput" 2> "$expOutput"
2041 grip-add 'd' > "$expOutput" 2> "$expOutput"
cd ..

cd "$temp_dir" || exit 1
grip-commit -m 'insanity' > "$impOutput" 2> "$impOutput"
grip-add 'd' > "$impOutput" 2> "$impOutput"
cd ..

# Testing Successful status, mix of committed
cd "$ref_dir" || exit 1
2041 grip-status > "$expOutput" 2> "$expOutput"
expCode="$?"
cd ..

cd "$temp_dir" || exit 1
grip-status > "$impOutput" 2> "$impOutput"
impCode="$?"
cd ..

testing="Successful Status - files committed"
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
echo hello >> a
echo nomre >> b
echo iahd >> c
2041 grip-add a > "$expOutput" 2> "$expOutput"
2041 grip-commit -m "lollol" > "$expOutput" 2> "$expOutput"
2041 grip-add b > "$expOutput" 2> "$expOutput"
cd ..

cd "$temp_dir" || exit 1
echo hello >> a
echo nomre >> b
echo iahd >> c
grip-add a > "$impOutput" 2> "$impOutput"
grip-commit -m "lollol" > "$impOutput" 2> "$impOutput"
grip-add b > "$impOutput" 2> "$impOutput"
cd ..

# Testing Successful status, mix of file edit stages
cd "$ref_dir" || exit 1
2041 grip-status > "$expOutput" 2> "$expOutput"
expCode="$?"
cd ..

cd "$temp_dir" || exit 1
grip-status > "$impOutput" 2> "$impOutput"
impCode="$?"
cd ..

testing="Successful Status - Mixed file stages"
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
2041 grip-commit -m "lollol" > "$expOutput" 2> "$expOutput"
2041 grip-branch b > "$expOutput" 2> "$expOutput"
2041 grip-checkout b > "$expOutput" 2> "$expOutput"
touch hello
2041 grip-add hello > "$expOutput" 2> "$expOutput"
2041 grip-commit -m 'branch test' > "$expOutput" 2> "$expOutput"
2041 grip-checkout trunk > "$expOutput" 2> "$expOutput" 
cd ..

cd "$temp_dir" || exit 1
grip-commit -m "lollol" > "$impOutput" 2> "$impOutput"
grip-branch b > "$impOutput" 2> "$impOutput"
grip-checkout b > "$impOutput" 2> "$impOutput"
touch hello
grip-add hello > "$impOutput" 2> "$impOutput"
grip-commit -m "branch test" > "$impOutput" 2> "$impOutput"
grip-checkout trunk > "$impOutput" 2> "$impOutput"
cd ..

# Testing Successful status, branch
cd "$ref_dir" || exit 1
2041 grip-status > "$expOutput" 2> "$expOutput"
expCode="$?"
cd ..

cd "$temp_dir" || exit 1
grip-status > "$impOutput" 2> "$impOutput"
impCode="$?"
cd ..

testing="Successful Status - Branch files"
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