#! /bin/sh
# Example usage:
# zeek_conn_log_full.sh zeek_conn_log_full.data | clickhouse-client --query="INSERT INTO zeek_conn_log_full FORMAT TabSeparated"

FILENAME=$(echo $1 | cut -d"." -f2- | sed 's/^/conn./g')
FILEDATE=$(echo $1 | cut -d"." -f4 | cut -d"-" -f-3)

# excluse comments / headers
zfgrep -v "#" $1 | \
# add file date and duplicate rows with different ip column for primary key
gawk -v FILEVAR="$FILENAME" -v DATEVAR="$FILEDATE" '{print DATEVAR"\t"$3"\t"FILEVAR"\t"$0"\n"DATEVAR"\t"$5"\t"FILEVAR"\t"$0}'

exit
