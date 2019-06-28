#! /bin/sh
###############################################################################
# Ingest script for Zeek logs into Clickhouse.
#
# MNSmitasin@lbl.gov 2019-06-16
# zeek_build_candidates.sh | xargs -n1 -I% zeek_ingest.sh %
# cat 10day | xargs -n1 -I% zeek_ingest.sh %
# ADD: -m to verify metadata (filename, path, etc)
# ADD: -v to verify data added to stream (date, file_src)
#
###############################################################################
### LOCAL VARIABLES

# Contact
MAILTO="admin@example.com"

FULLPATH="$1"
FILENAME="$(basename $FULLPATH)"
FILESRC="$(echo $FILENAME | cut -d"." -f3)"
FILEDATE="$(echo $FILENAME | cut -d"." -f4 | cut -d"-" -f-3)"
DIRONLY="$(dirname $FULLPATH)"

###############################################################################
### FUNCTIONS

VERIFYMETADATA(){
        echo "$FULLPATH,$FILESRC,$FILEDATE,$DIRONLY"
}

VERIFYADDDATA(){
        zgrep -v "^#" $FULLPATH | \
                head -1 | \
                gawk -v FILESRC="$FILESRC" -v FILEDATE="$FILEDATE" -F '\t' 'BEGIN {OFS = FS} {print \
                FILEDATE "\t" FILESRC }'
}

FORMATCONN(){
        zgrep -v "^#" $FULLPATH | \
                gawk -v FILESRC="$FILESRC" -v FILEDATE="$FILEDATE" -F '\t' 'BEGIN {OFS = FS} {print \
                FILEDATE "\t" FILESRC "\t" $3 "\t" $1 "\t" $2 "\t" $3 "\t" $4 "\t" $5 "\t" $6 "\t" $7 "\t" $8 \
                "\t" $9 "\t" $10 "\t" $11 "\t" $12 "\t" $13 "\t" $14 "\t" $15 "\t" $16 \
                "\t" $17 "\t" $18 "\t" $19 "\t" $20 "\t" $21 "\t" $22 "\t" $23 "\t" $24 "\n" \
                FILEDATE "\t" FILESRC "\t" $5 "\t" $1 "\t" $2 "\t" $3 "\t" $4 "\t" $5 "\t" $6 "\t" $7 "\t" $8 \
                "\t" $9 "\t" $10 "\t" $11 "\t" $12 "\t" $13 "\t" $14 "\t" $15 "\t" $16 \
                "\t" $17 "\t" $18 "\t" $19 "\t" $20 "\t" $21 "\t" $22 "\t" $23 "\t" $24 }'
}

FORMATDNS(){
        zgrep -v "^#" $FULLPATH | \
                gawk -v FILESRC="$FILESRC" -v FILEDATE="$FILEDATE" -F '\t' 'BEGIN {OFS = FS} {print \
                FILEDATE "\t" FILESRC "\t" $0 }'
}

FORMATFILES(){
        zgrep -v "^#" $FULLPATH | \
                gawk -v FILESRC="$FILESRC" -v FILEDATE="$FILEDATE" -F '\t' 'BEGIN {OFS = FS} {print \
                FILEDATE "\t" FILESRC "\t" $1 "\t" $2 "\t" $3 "\t" $4 "\t" $5 "\t" $6 "\t" $7 "\t" $8 "\t" $9 "\t" $10 "\t" $11 "\t" $12 \
                "\t" $13 "\t" $14 "\t" $15 "\t" $16 "\t" $17 "\t" $18 "\t" $19 "\t" $20 "\t" $21 "\t" $22 "\t" $23 }'
}

FORMATHTTP(){
        zgrep -v "^#" $FULLPATH | \
                gawk -v FILESRC="$FILESRC" -v FILEDATE="$FILEDATE" -F '\t' 'BEGIN {OFS = FS} {print \
                FILEDATE "\t" FILESRC "\t" $1 "\t" $2 "\t" $3 "\t" $4 "\t" $5 "\t" $6 "\t" $7 "\t" $9 "\t" $10 "\t" $11 "\t" $12 "\t" $14 }
}

FORMATSMTP(){
        zgrep -v "^#" $FULLPATH | \
                gawk -v FILESRC="$FILESRC" -v FILEDATE="$FILEDATE" -F '\t' 'BEGIN {OFS = FS} {print \
                FILEDATE "\t" FILESRC "\t" $0 }'
}

FORMATSSL(){
        zgrep -v "^#" $FULLPATH | \
                gawk -v FILESRC="$FILESRC" -v FILEDATE="$FILEDATE" -F '\t' 'BEGIN {OFS = FS} {print \
                FILEDATE "\t" FILESRC "\t" $0 }'
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
# logger "$0 - Exited cleanly"
exit 0
