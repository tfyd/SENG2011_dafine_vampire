#!/bin/sh

# Move testing directory
BASEDIR=$(dirname "$0")
cd $BASEDIR/../

# Test
echo "Test 5 - StoreHouse Manger Test"
# Type all 4 functions
echo -e '1\n1\n04/11/2000 12:12\n\nb\n2\n1\n1\nY\nO\n25/11/2001 15:16\n\n\b\nb\nb\n4\n1\n1\n\nb\nq\n' | python3 main.py > /dev/null
echo "Test 5 passed"