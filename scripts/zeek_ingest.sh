#! /bin/sh
###############################################################################
# Ingest script for Zeek logs into Clickhouse.
#
# MNSmitasin@lbl.gov 2021-06-24
#
# Dependencies:
# (Note: this was written for Linux/Ubuntu, some changes may be needed for other OSes)
# gawk
# zeek-cut
# 
# Example:
# zeek_ingest.sh conn.log -m            verify metadata (filename, path, etc)
# zeek_ingest.sh conn.log -v            verify data added to stream (date, file_src)
# zeek_ingest.sh conn.log | clickhouse-client --query="INSERT INTO zeek-conn FORMAT TabSeparated"
#
###############################################################################
### LOCAL VARIABLES

# Contact
MAILTO="admin@example.com"

FULLPATH="$1"
FILENAME="$(basename $FULLPATH)"
FILESRC="$(echo $FILENAME | cut -d"." -f3)"
DIRONLY="$(dirname $FULLPATH)"
ZEEKCUTPATH="/usr/local/bin/zeek-cut"

###############################################################################
### FUNCTIONS

VERIFYMETADATA(){
        echo "$FULLPATH,$FILESRC,$DIRONLY"
}

VERIFYADDDATA(){
        zgrep -v "^#" $FULLPATH | \
                # XXX comment out below for prod
                head -1 | \
                gawk -v FILESRC="$FILESRC" -F '\t' 'BEGIN {OFS = FS} {print \
                FILESRC }'
}

FORMATCONN(){
        zcat $FULLPATH | \
                $ZEEKCUTPATH ts uid id.orig_h id.orig_p id.resp_h id.resp_p proto service duration orig_bytes resp_bytes conn_state local_orig local_resp missed_bytes history orig_pkts orig_ip_bytes resp_pkts resp_ip_bytes tunnel_parents | sed "s/$/\t$FILESRC/g;"
}

FORMATDNS(){
        zcat $FULLPATH | \
                $ZEEKCUTPATH ts uid id.orig_h id.orig_p id.resp_h id.resp_p proto trans_id rtt query qclass qclass_name qtype qtype_name rcode rcode_name AA TC RD RA Z answers TTLs rejected | sed "s/$/\t$FILESRC/g;"
}

FORMATFILES(){
        zcat $FULLPATH | \
                $ZEEKCUTPATH ts fuid tx_hosts rx_hosts conn_uids source depth analyzers mime_type filename duration local_orig is_orig seen_bytes total_bytes missing_bytes overflow_bytes timedout parent_fuid md5 sha1 sha256 extracted | sed "s/$/\t$FILESRC/g;"
}

FORMATHTTP(){
        zcat $FULLPATH | \
                $ZEEKCUTPATH ts uid id.orig_h id.orig_p id.resp_h id.resp_p trans_depth method host uri referrer version user_agent status_code | sed "s/$/\t$FILESRC/g;"
}

FORMATSMTP(){
        zcat $FULLPATH | \
                $ZEEKCUTPATH ts uid id.orig_h id.orig_p id.resp_h id.resp_p trans_depth helo mailfrom rcptto date from to cc reply_to msg_id in_reply_to subject x_originating_ip first_received second_received last_reply path user_agent tls fuids is_webmail | sed "s/$/\t$FILESRC/g;"
}

FORMATSSL(){
        zcat $FULLPATH | \
                $ZEEKCUTPATH ts uid id.orig_h id.orig_p id.resp_h id.resp_p version cipher curve server_name resumed last_alert next_protocol established cert_chain_fuids client_cert_chain_fuids subject issuer client_subject client_issuer validation_status | sed "s/$/\t$FILESRC/g;"
}

FORMATDATA(){
        case $FILENAME in
                *conn*) TABLE="zeek_conn"; FORMATCONN;;
                *dns*) TABLE="zeek_dns"; FORMATDNS;;
                *files*) TABLE="zeek_files"; FORMATFILES;;
                *http*) TABLE="zeek_http"; FORMATHTTP;;
                *smtp*) TABLE="zeek_smtp"; FORMATSMTP;;
                *ssl*) TABLE="zeek_ssl"; FORMATSSL;;
                *) echo "ERROR, log type not defined for ingest!" ; exit 1 ;;
        esac
}

###############################################################################
### EXECUTION

# add options to verify data before import
case $2 in
        -m) VERIFYMETADATA ;;
        -v) VERIFYADDDATA ;;
        *) FORMATDATA ;;
esac

###############################################################################
### CLEANUP, log, exit cleanly
exit 0
