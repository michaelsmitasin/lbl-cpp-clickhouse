#! /bin/sh
# Example usage:
# zeek_conn_log_verysmall_ingest.sh zeek_conn_log_verysmall.data | clickhouse-client --query="INSERT INTO zeek_conn_log_verysmall FORMAT TabSeparated"

# excluse comments / headers
zfgrep -v "#" $1 | \
# convert time format
gawk '{print strftime("%Y-%m-%d", $1)"\t"$3"\n"strftime("%Y-%m-%d", $1)"\t"$5}' 

exit
