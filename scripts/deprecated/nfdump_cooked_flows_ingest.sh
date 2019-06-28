#! /bin/sh
# 2019-01-08: Michael Smitasin
# assumes nfdump flags like:
# nfdump -N -r nfcapd.201901081100 -q -o extended >> nfdump_cooked_flows.data
# Example usage:
# nfdump_cooked_flows_ingest.sh nfdump_cooked_flows.data | clickhouse-client --query="INSERT INTO nfdump_cooked_flows FORMAT CSV"

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
