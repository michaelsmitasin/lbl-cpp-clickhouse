#! /bin/sh
# Example usage:
# zeek_conn_log_optimized.sh zeek_conn_log_optimized.data | clickhouse-client --query="INSERT INTO zeek_conn_log_optimized FORMAT TabSeparated"

FILENAME=$(echo $1 | cut -d "/" -f5)
FILEDATE=$(echo $1 | cut -d"." -f4 | cut -d"-" -f-3)

# excluse comments / headers
zfgrep -v "#" $1 | \
# add file date and duplicate rows with different ip column for primary key
# import only specific columns to be optimized
# day = $FILEDATE
# ip = $3 or $5
# file_src = $FILENAME
# orig_h = $3
# orig_p = $4
# resp_ha = $5
# resp_p = $6
# proto = $7
# conn_state = $12
gawk -v FILEVAR="$FILENAME" -v DATEVAR="$FILEDATE" '{print DATEVAR"\t"$3"\t"FILEVAR"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7"\t"$12 "\n" DATEVAR"\t"$5"\t"FILEVAR"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7"\t"$12}'

exit
