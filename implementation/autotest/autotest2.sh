#!/bin/sh

# Move testing directory
BASEDIR=$(dirname "$0")
cd $BASEDIR/../

# Test
echo "Test 2 - Donation Manager Test"
echo -e '1\n1\n04/11/2019 12:00\n\n2\n\nb\nq\n' | python3 main.py > /dev/null
echo "Test 2 passed"