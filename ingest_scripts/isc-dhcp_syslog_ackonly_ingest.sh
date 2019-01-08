#! /bin/sh
# 2019-01-08: Michael Smitasin
# Example usage:
# isc-dhcp_syslog_ackonly_ingest.sh dhcpd-2018-11-13.gz | clickhouse-client --query="INSERT INTO isc-dhcp_syslog_ackonly FORMAT CSV"

# return only DHCPACK log messages
zfgrep DHCPACK $1 | \
# format date
sed 's/^/2018 /g;s/Nov/11/1;s/:/ /1;s/:/ /1;s/ /_/3;s/ /_/5' | \
# add seconds
gawk -F_ '{$2=mktime($1" "$2); print $0}' | \
# add dashes to date
sed 's/ /-/1;s/ /-/1' | \
# if column 8 contains "to", clear it 
awk '{if ($8=="to") $8=""; print $0}' | sed 's/  / /g' | \
# replace " via " with an easy delimiter so we can drop anything after it
sed 's/ via /#/g' | cut -d "#" -f1 | \
# if there's no DDNS hostname, set the column to an placeholder
awk '{if ($9=="") $9="(NOHOSTNAME)"; print $0}' | \
# drop columns we don't need
cut -d " " -f1,2,3,7,8,9- | \
# replace first 5 spaces with commas
sed 's/ /,/1;s/ /,/1;s/ /,/1;s/ /,/1;s/ /,/1' | \
# drop paranthesis
tr -d "(" | tr -d ")"

exit
