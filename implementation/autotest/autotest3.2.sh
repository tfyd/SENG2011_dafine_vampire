#!/bin/sh

# Move testing directory
BASEDIR=$(dirname "$0")
cd $BASEDIR/../

# Test
echo "Test 3.2 - Tester Test - Pass test"
# Type Y
echo -e '1\n1\n04/11/2019 12:12\n\nb\n2\n1\n1\n\nb\n2\n1\nY\nO\n25/11/2025 15:16\n\nb\nq\n' | python3 main.py > /dev/null
if [ $? -ne 0 ]
then
    exit 1
fi

echo "Test 3.2 passed"

