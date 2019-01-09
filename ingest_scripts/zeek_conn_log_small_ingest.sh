#! /bin/sh
# Example usage:
# zeek_conn_log_small_ingest.sh conn.log | clickhouse-client --query="INSERT INTO zeek_conn_log_small FORMAT TabSeparated"

# excluse comments / headers
zfgrep -v "#" $1 | \
# convert time format
gawk '{print strftime("%Y-%m-%d", $1)"\t"$3"\t"$5}' 

exit
