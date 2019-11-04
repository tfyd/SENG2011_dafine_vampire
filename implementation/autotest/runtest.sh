#!/bin/sh

# Move testing directory
BASEDIR=$(dirname "$0")
cd $BASEDIR/../

for f in $(find -name 'autotest*.sh')
do
  bash "$f"
done