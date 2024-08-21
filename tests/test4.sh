#!/bin/dash

# test4.sh tests the grip-show command.
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
2041 grip-show > "$expOutput" 2> "$expOutput"
expCode="$?"
cd ..

cd "$temp_dir" || exit 1
grip-show > "$impOutput" 2> "$impOutput"
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
echo "some message" > a
2041 grip-add 'a' > "$expOutput" 2> "$expOutput"
2041 grip-commit -m 'commit-a' > "$expOutput" 2> "$expOutput"
2041 grip-branch hello > "$impOutput" 2> "$impOutput"
2041 grip-checkout hello > "$impOutput" 2> "$impOutput"
2041 grip-add 'b' > "$impOutput" 2> "$impOutput"
2041 grip-commit -m 'commit-b' > "$impOutput" 2> "$impOutput"
2041 grip-checkout trunk > "$impOutput" 2> "$impOutput"
cd ..

cd "$temp_dir" || exit 1
grip-init > "$impOutput" 2> "$impOutput"
touch a b c d
echo "some message" > a
grip-add 'a' > "$impOutput" 2> "$impOutput"
grip-commit -m 'commit-a' > "$impOutput" 2> "$impOutput"
grip-branch hello > "$impOutput" 2> "$impOutput"
grip-checkout hello > "$impOutput" 2> "$impOutput"
grip-add 'b' > "$impOutput" 2> "$impOutput"
grip-commit -m 'commit-b' > "$impOutput" 2> "$impOutput"
grip-checkout trunk > "$impOutput" 2> "$impOutput"
cd ..

# Testing ======================================================================

# Testing Usage
cd "$ref_dir" || exit 1
2041 grip-show 'a' > "$expOutput" 2> "$expOutput"
expCode="$?"
cd ..

cd "$temp_dir" || exit 1
grip-show 'a' > "$impOutput" 2> "$impOutput"
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

# Testing normal check
cd "$ref_dir" || exit 1
2041 grip-show 0:a > "$expOutput" 2> "$expOutput"
expCode="$?"
cd ..

cd "$temp_dir" || exit 1
grip-show 0:a > "$impOutput" 2> "$impOutput"
impCode="$?"
cd ..

testing="Normal check"
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

# Testing not on current branch check
cd "$ref_dir" || exit 1
2041 grip-show 1:b > "$expOutput" 2> "$expOutput"
expCode="$?"
cd ..

cd "$temp_dir" || exit 1
grip-show 1:b > "$impOutput" 2> "$impOutput"
impCode="$?"
cd ..

testing="Not on current branch check"
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

# Testing file not in commit
cd "$ref_dir" || exit 1
2041 grip-show 0:b > "$expOutput" 2> "$expOutput"
expCode="$?"
cd ..

cd "$temp_dir" || exit 1
grip-show 0:b > "$impOutput" 2> "$impOutput"
impCode="$?"
cd ..

testing="File not in commit"
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

# Testing index
cd "$ref_dir" || exit 1
2041 grip-show :b > "$expOutput" 2> "$expOutput"
expCode="$?"
cd ..

cd "$temp_dir" || exit 1
grip-show :b > "$impOutput" 2> "$impOutput"
impCode="$?"
cd ..

testing="Index file - 1"
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

# Testing index - 2
cd "$ref_dir" || exit 1
2041 grip-show :a > "$expOutput" 2> "$expOutput"
expCode="$?"
cd ..

cd "$temp_dir" || exit 1
grip-show :a > "$impOutput" 2> "$impOutput"
impCode="$?"
cd ..

testing="Index file - 2"
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

# Testing invalid filename
cd "$ref_dir" || exit 1
2041 grip-show 0:+ASdsaS > "$expOutput" 2> "$expOutput"
expCode="$?"
cd ..

cd "$temp_dir" || exit 1
grip-show 0:+ASdsaS > "$impOutput" 2> "$impOutput"
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

# Testing invalid filename and index
cd "$ref_dir" || exit 1
2041 grip-show :+ASdsaS > "$expOutput" 2> "$expOutput"
expCode="$?"
cd ..

cd "$temp_dir" || exit 1
grip-show :+ASdsaS > "$impOutput" 2> "$impOutput"
impCode="$?"
cd ..

testing="Invalid filename and index"
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

# Testing empty filename
cd "$ref_dir" || exit 1
2041 grip-show 0: > "$expOutput" 2> "$expOutput"
expCode="$?"
cd ..

cd "$temp_dir" || exit 1
grip-show 0: > "$impOutput" 2> "$impOutput"
impCode="$?"
cd ..

testing="Empty Filename"
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

# Testing empty filename and index
cd "$ref_dir" || exit 1
2041 grip-show : > "$expOutput" 2> "$expOutput"
expCode="$?"
cd ..

cd "$temp_dir" || exit 1
grip-show : > "$impOutput" 2> "$impOutput"
impCode="$?"
cd ..

testing="Empty filename and index"
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

# Testing non-numerical commit
cd "$ref_dir" || exit 1
2041 grip-show sda: > "$expOutput" 2> "$expOutput"
expCode="$?"
cd ..

cd "$temp_dir" || exit 1
grip-show sda: > "$impOutput" 2> "$impOutput"
impCode="$?"
cd ..

testing="Non-numerical commit"
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

# Testing funky commit numbering
cd "$ref_dir" || exit 1
2041 grip-show 00000:a > "$expOutput" 2> "$expOutput"
expCode="$?"
cd ..

cd "$temp_dir" || exit 1
grip-show 00000:a > "$impOutput" 2> "$impOutput"
impCode="$?"
cd ..

testing="Funky commit Numbering"
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

