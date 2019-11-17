#!/bin/sh

# Move testing directory
BASEDIR=$(dirname "$0")
cd $BASEDIR/../

# Test
echo "Test 4 - Doctor Test"
# Type all 2 functions
echo -e '1\n1\n04/11/2019 12:12\n\nb\n2\n1\n1\n\nb\n2\n1\nY\nO\n25/11/2028 15:16\n\n\b\nb\n3\n3\nAA\nO\n\n4\n\n1\n\n2\n1\n\nb\nq\n' | python3 main.py > /dev/null
if [ $? -ne 0 ]
then
    exit 1
fi
echo "Test 4 passed"
