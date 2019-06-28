#! /bin/sh
# Example usage:
# zeek_conn_log_optimized.sh zeek_conn_log_optimized.data | clickhouse-client --query="INSERT INTO zeek_conn_log_optimized FORMAT TabSeparated"

FILEDATE=$(echo $1 | cut -d"." -f4 | cut -d"-" -f-3)

# day = $1
# ts = $2
# orig_h = $4
# orig_p = $5
# resp_h = $6
# resp_p = $7
# method = $9
# host = $10
# uri = $11
# referrer = $12
# user_agent = $14
# status_code = $17
# status_msg = $18

# excluse comments / headers
zfgrep -v "#" $1 | \
# add file date
sed "s/^/$FILEDATE\t/g" | awk -F '\t'  'BEGIN {OFS = FS} {print $1"\t"$2"\t"$4"\t"$5"\t"$6"\t"$7"\t"$9"\t"$10"\t"$11"\t"$12"\t"$14"\t"$17"\t"$18}'

exit
