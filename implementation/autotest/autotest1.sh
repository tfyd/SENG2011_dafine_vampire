#!/bin/sh

# Move testing directory
BASEDIR=$(dirname "$0")
cd $BASEDIR/../

# Test
echo "Test 1 - trivial"
echo -e '1\nb\n2\nb\n3\nb\n4\nb\nq\n' | python3 main.py > /dev/null
if [ $? -ne 0 ]
then
    exit 1
fi
echo "Test 1 passed"

