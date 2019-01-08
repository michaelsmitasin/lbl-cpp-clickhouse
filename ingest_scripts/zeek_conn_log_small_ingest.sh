#! /bin/sh

# excluse comments / headers
zfgrep -v "#" $1 | \
# convert time format
gawk '{print strftime("%Y-%m-%d", $1)"\t"$3"\t"$5}' 

exit
