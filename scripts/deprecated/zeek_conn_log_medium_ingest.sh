#! /bin/sh
# Example usage:
# zeek_conn_log_medium.sh zeek_conn_log_medium.data | clickhouse-client --query="INSERT INTO zeek_conn_log_medium FORMAT TabSeparated"

FILEDATE=$(echo $1 | cut -d"." -f4 | cut -d"-" -f-3)

# excluse comments / headers
zfgrep -v "#" $1 | \
# insert filedate and trim fields
gawk -v DATEVAR="$FILEDATE" '{print DATEVAR"\t"$3"\t"$1"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7"\n"DATEVAR"\t"$5"\t"$1"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7}'

exit
