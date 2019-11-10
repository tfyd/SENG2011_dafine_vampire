#!/bin/sh

# Move testing directory
BASEDIR=$(dirname "$0")
cd $BASEDIR/../

# Test
echo "Test 5 - StoreHouse Manger Test"
# Test dispose one function
echo -e '1\n1\n04/11/2000 12:12\n\nb\n2\n1\n1\n\nb\n2\n1\nY\nO\n25/11/2001 15:16\n\n\b\nb\nb\n4\n1\n1\n\nb\nq\n' | python3 main.py > /dev/null
# Test dispose all function
echo -e '1\n1\n04/11/2001 12:12\n\nb\n2\n1\n1\n\nb\n2\n1\nY\nO\n25/11/2002 15:16\n\n\b\nb\nq\n' | python3 main.py > /dev/null
echo -e '1\n1\n04/11/2002 12:12\n\nb\n2\n1\n1\n\nb\n2\n1\nY\nO\n25/11/2003 15:16\n\n\b\nb\nq\n' | python3 main.py > /dev/null
echo -e '4\n3\nN\n3\nY\n\nb\nq\n' | python3 main.py > /dev/null
# Test view stock level functions
echo -e '4\n4\n\n5\n03/02/2002 12:12\n\n5\n03/02/2322 18:16\n\nq\n' | python3 main.py > /dev/null
echo "Test 5 passed"