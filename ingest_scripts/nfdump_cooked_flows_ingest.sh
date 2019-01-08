#! /bin/sh

# Convert date/time to epoch seconds using gawk mktime, then format for ingestion to clickhouse
zcat $1 | \
sed 's/-/ /1;s/-/ /1;s/:/ /1;s/:/ /1' | \
gawk '{SECS=mktime($1" "$2" "$3" "$4" "$5" "$6); $4=SECS; $5=""; $6=""; print $0}' | \
sed 's/ /-/1;s/ /-/1' | \
# Conver to CSV
tr ":" "," | \
sed 's/ -> /,/g' | \
tr " " "," | \
sed 's/,,,/,/g' 

exit
