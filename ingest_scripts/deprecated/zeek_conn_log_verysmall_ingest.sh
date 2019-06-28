#! /bin/sh
# Example usage:
# zeek_conn_log_verysmall_ingest.sh zeek_conn_log_verysmall.data | clickhouse-client --query="INSERT INTO zeek_conn_log_verysmall FORMAT TabSeparated"

FILEDATE=$(echo $1 | cut -d"." -f4 | cut -d"-" -f-3)

# excluse comments / headers
zfgrep -v "#" $1 | \
# convert time format
gawk -v DATEVAR="$FILEDATE" '{print DATEVAR"\t"$3"\n"DATEVAR"\t"$5}' 

exit
