#!/bin/bash

if [ $# -ne 1 ]
then
  echo "Usage: <installation prefix base>" >&2
fi

INSTALL_PREFIX_BASE="$1"

for target_descriptor_file in target-descriptors/*
do
  target_descriptor=`basename ${target_descriptor_file}`
  ./build.sh ${INSTALL_PREFIX_BASE}/${target_descriptor} ${target_descriptor} || exit $?
done
