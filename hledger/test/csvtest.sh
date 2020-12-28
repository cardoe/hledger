#!/bin/sh
#
# This scripts expects stdin formatted like this:
# <multi-line csv file>
# RULES
# <multi-line rules>
#
cat > t.$$.csv
sed '1,/^RULES/d' t.$$.csv > t.$$.csv.rules
sed -i '/^RULES/,$d' t.$$.csv

trap 'rm -f t.$$.csv t.$$.csv.rules t.$$.stderr' EXIT

# Remove variable file name from error messages
mkfifo t.$$.stderr
sed -Ee "s/t\.$$\.csv/input/" t.$$.stderr >&2 &

hledger -f csv:t.$$.csv --rules-file t.$$.csv.rules print "$@" 2> t.$$.stderr
