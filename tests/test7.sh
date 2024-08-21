#!/bin/dash

# test7.sh tests the grip-branch command.
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
2041 grip-branch > "$expOutput" 2> "$expOutput"
expCode="$?"
cd ..

cd "$temp_dir" || exit 1
grip-branch > "$impOutput" 2> "$impOutput"
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
2041 grip-branch -h > "$expOutput" 2> "$expOutput"
expCode="$?"
cd ..

cd "$temp_dir" || exit 1
grip-branch -h > "$impOutput" 2> "$impOutput"
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

# Testing grip-branch before commit
cd "$ref_dir" || exit 1
2041 grip-branch > "$expOutput" 2> "$expOutput"
expCode="$?"
cd ..

cd "$temp_dir" || exit 1
grip-branch > "$impOutput" 2> "$impOutput"
impCode="$?"
cd ..

testing="Grip-branch no commits"
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

# Testing grip-branch create before commit
cd "$ref_dir" || exit 1
2041 grip-branch d > "$expOutput" 2> "$expOutput"
expCode="$?"
cd ..

cd "$temp_dir" || exit 1
grip-branch d > "$impOutput" 2> "$impOutput"
impCode="$?"
cd ..

testing="Grip-branch create no commits"
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
2041 grip-commit -m 'a' > "$expOutput" 2> "$expOutput"
cd ..

cd "$temp_dir" || exit 1
grip-commit -m 'a' > "$impOutput" 2> "$impOutput"
cd ..

# Testing Listing Branch - Just trunk
cd "$ref_dir" || exit 1
2041 grip-branch > "$expOutput" 2> "$expOutput"
expCode="$?"
cd ..

cd "$temp_dir" || exit 1
grip-branch > "$impOutput" 2> "$impOutput"
impCode="$?"
cd ..

testing="Listing Branch - Just Trunk"
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

# Testing Creating branch
cd "$ref_dir" || exit 1
2041 grip-branch hello > "$expOutput" 2> "$expOutput"
expCode="$?"
cd ..

cd "$temp_dir" || exit 1
grip-branch hello > "$impOutput" 2> "$impOutput"
impCode="$?"
cd ..

testing="Creating branch"
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

# Testing Listing Branch
cd "$ref_dir" || exit 1
2041 grip-branch > "$expOutput" 2> "$expOutput"
expCode="$?"
cd ..

cd "$temp_dir" || exit 1
grip-branch > "$impOutput" 2> "$impOutput"
impCode="$?"
cd ..

testing="Listing Branch - 2 branches"
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

# Testing Delete trunk branch
cd "$ref_dir" || exit 1
2041 grip-branch -d trunk > "$expOutput" 2> "$expOutput"
expCode="$?"
cd ..

cd "$temp_dir" || exit 1
grip-branch -d trunk > "$impOutput" 2> "$impOutput"
impCode="$?"
cd ..

testing="Deleting Trunk"
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

# Testing Delete side branch
cd "$ref_dir" || exit 1
2041 grip-branch -d hello > "$expOutput" 2> "$expOutput"
expCode="$?"
cd ..

cd "$temp_dir" || exit 1
grip-branch -d hello > "$impOutput" 2> "$impOutput"
impCode="$?"
cd ..

testing="Deleting side branch"
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

# Testing Delete nonexistent branch
cd "$ref_dir" || exit 1
2041 grip-branch -d hello > "$expOutput" 2> "$expOutput"
expCode="$?"
cd ..

cd "$temp_dir" || exit 1
grip-branch -d hello > "$impOutput" 2> "$impOutput"
impCode="$?"
cd ..

testing="Deleting nonexistent branch"
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

# Testing Creating side branch again
cd "$ref_dir" || exit 1
2041 grip-branch hello > "$expOutput" 2> "$expOutput"
expCode="$?"
cd ..

cd "$temp_dir" || exit 1
grip-branch hello > "$impOutput" 2> "$impOutput"
impCode="$?"
cd ..

testing="Creating side branch again"
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
2041 grip-checkout hello > "$expOutput" 2> "$expOutput"
cd ..

cd "$temp_dir" || exit 1
grip-checkout hello > "$impOutput" 2> "$impOutput"
cd ..

# Testing deleting current branch
cd "$ref_dir" || exit 1
2041 grip-branch -d hello > "$expOutput" 2> "$expOutput"
expCode="$?"
cd ..

cd "$temp_dir" || exit 1
grip-branch -d hello > "$impOutput" 2> "$impOutput"
impCode="$?"
cd ..

testing="Deleting current branch"
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
2041 grip-branch 'duplicateBranch2' > "$expOutput" 2> "$expOutput"
2041 grip-add 'a' 'b' 'c' 'd' > "$expOutput" 2> "$expOutput"
2041 grip-commit -m "unmerged" > "$expOutput" 2> "$expOutput"
2041 grip-branch 'duplicateBranch' > "$expOutput" 2> "$expOutput"
2041 grip-checkout trunk > "$expOutput" 2> "$expOutput"
cd ..

cd "$temp_dir" || exit 1
grip-branch 'duplicateBranch2' > "$impOutput" 2> "$impOutput"
grip-add 'a' 'b' 'c' 'd' > "$impOutput" 2> "$impOutput"
grip-commit -m "unmerged" > "$impOutput" 2> "$impOutput"
grip-branch 'duplicateBranch' > "$impOutput" 2> "$impOutput"
grip-checkout trunk > "$impOutput" 2> "$impOutput"
cd ..

# Testing successful deletion of duplicate
cd "$ref_dir" || exit 1
2041 grip-branch -d duplicateBranch2 > "$expOutput" 2> "$expOutput"
expCode="$?"
cd ..

cd "$temp_dir" || exit 1
grip-branch -d duplicateBranch2 > "$impOutput" 2> "$impOutput"
impCode="$?"
cd ..

testing="Failure Deleting duplicate branch"
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

# Testing failing deletion of duplicate
cd "$ref_dir" || exit 1
2041 grip-branch -d duplicateBranch > "$expOutput" 2> "$expOutput"
expCode="$?"
cd ..

cd "$temp_dir" || exit 1
grip-branch -d duplicateBranch > "$impOutput" 2> "$impOutput"
impCode="$?"
cd ..

testing="Failure Deleting duplicate branch"
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

# Testing unmerged changes
cd "$ref_dir" || exit 1
2041 grip-branch -d hello > "$expOutput" 2> "$expOutput"
expCode="$?"
cd ..

cd "$temp_dir" || exit 1
grip-branch -d hello > "$impOutput" 2> "$impOutput"
impCode="$?"
cd ..

testing="Delete failed, unmerged changes"
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