#!/bin/sh

# Move testing directory
BASEDIR=$(dirname "$0")
cd $BASEDIR/../

for f in $(find -name 'autotest*.sh')
do
  bash "$f"
  if [ $? -ne 0 ]
  then
    echo "Test in $f failed"
    exit 1
  fi
done

echo "All autotests passed"
