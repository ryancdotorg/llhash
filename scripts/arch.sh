#!/bin/bash
set -uo pipefail
trap 's=$?; echo ": Error on line "$LINENO": $BASH_COMMAND"; exit $s' ERR
IFS=$'\t\n'

ARCH="${1:-native}"
echo "-DARCH=$(gcc -march="$ARCH" -Q --help=target | grep -- '^\s*-march=' | cut -f3 | tr -- - _)"
gcc -march="$ARCH" -Q --help=target 2> /dev/null | \
tr a-z.- A-Z__ | \
grep -E '\[ENABLED\]' | \
sed -E 's/^\s+_M(\S+).*/-D__ARCH_HAS_\1__/'
