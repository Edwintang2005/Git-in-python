#!/bin/dash

# test3.sh tests the grip-log command.
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
2041 grip-log > "$expOutput" 2> "$expOutput"
expCode="$?"
cd ..

cd "$temp_dir" || exit 1
grip-log > "$impOutput" 2> "$impOutput"
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
2041 grip-log 'a' > "$expOutput" 2> "$expOutput"
expCode="$?"
cd ..

cd "$temp_dir" || exit 1
grip-log 'a' > "$impOutput" 2> "$impOutput"
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

# Testing No Commits
cd "$ref_dir" || exit 1
2041 grip-log > "$expOutput" 2> "$expOutput"
expCode="$?"
cd ..

cd "$temp_dir" || exit 1
grip-log > "$impOutput" 2> "$impOutput"
impCode="$?"
cd ..

testing="No Commits"
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
2041 grip-commit -m "commit_1" > "$expOutput" 2> "$expOutput"
cd ..

cd "$temp_dir" || exit 1
grip-commit -m "commit_1" > "$impOutput" 2> "$impOutput"
cd ..

# Testing One commit
cd "$ref_dir" || exit 1
2041 grip-log > "$expOutput" 2> "$expOutput"
expCode="$?"
cd ..

cd "$temp_dir" || exit 1
grip-log > "$impOutput" 2> "$impOutput"
impCode="$?"
cd ..

testing="One Commit"
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
2041 grip-checkout 'hello' > "$expOutput" 2> "$expOutput"
2041 grip-add 'd' > "$expOutput" 2> "$expOutput"
2041 grip-commit -m "commit_2" > "$expOutput" 2> "$expOutput"
cd ..

cd "$temp_dir" || exit 1
grip-branch 'hello' > "$impOutput" 2> "$impOutput"
grip-checkout 'hello' > "$impOutput" 2> "$impOutput"
grip-add 'd' > "$impOutput" 2> "$impOutput"
grip-commit -m "commit_2" > "$impOutput" 2> "$impOutput"
cd ..

# Testing Two commit on Branch
cd "$ref_dir" || exit 1
2041 grip-log > "$expOutput" 2> "$expOutput"
expCode="$?"
cd ..

cd "$temp_dir" || exit 1
grip-log > "$impOutput" 2> "$impOutput"
impCode="$?"
cd ..

testing="Two Commits on Branch"
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
2041 grip-checkout 'trunk' > "$expOutput" 2> "$expOutput"
cd ..

cd "$temp_dir" || exit 1
grip-checkout 'trunk' > "$impOutput" 2> "$impOutput"
cd ..

# Testing One commit back on trunk
cd "$ref_dir" || exit 1
2041 grip-log > "$expOutput" 2> "$expOutput"
expCode="$?"
cd ..

cd "$temp_dir" || exit 1
grip-log > "$impOutput" 2> "$impOutput"
impCode="$?"
cd ..

testing="One Commit on Trunk"
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
echo hello >> d
2041 grip-add 'd' > "$expOutput" 2> "$expOutput"
2041 grip-commit -m "commit_3" > "$expOutput" 2> "$expOutput"
cd ..

cd "$temp_dir" || exit 1
echo hello >> d
grip-add 'd' > "$impOutput" 2> "$impOutput"
grip-commit -m "commit_3" > "$impOutput" 2> "$impOutput"
cd ..

# Testing Two commits back on trunk
cd "$ref_dir" || exit 1
2041 grip-log > "$expOutput" 2> "$expOutput"
expCode="$?"
cd ..

cd "$temp_dir" || exit 1
grip-log > "$impOutput" 2> "$impOutput"
impCode="$?"
cd ..

testing="Two Commits on Trunk - Verif Numbering"
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