#!/bin/bash

# Warning:      Back up what were there before running this.
# Prerequisite: Allow 1900 UDP in.
# TODO:         This is time-consuming. Optimize this with cURL or libminiupnpc
#               or whatever.

raw_output=$( upnpc -l )

entries=$( echo "$raw_output"                                                 |\
           grep -i -e '[0-9]* UDP'                                             \
                   -e '[0-9]* TCP'                                             )

sanitized_entries=$(                                                           \
           echo "$entries"                                                    |\
           grep -v 'DO_NOT_MODIFY' `# keep these`                             |\
           awk '{$1=$1;print}'     `# trim leading and trailing whitespaces`  |\
           tr -s ' '               `# squeeze repeated whitespaces`            )

sanitized_entry_num=$( echo "$sanitized_entries" | wc -l )

idx=($(    echo "$sanitized_entries"                                          |\
           cut -f 1 -d ' '                                                    ))

proto=($(  echo "$sanitized_entries"                                          |\
           cut -f 2 -d ' '                                                    |\
           tr '[:lower:]' '[:upper:]' `# the client only accepts uppercase`   ))

port=($(   echo "$sanitized_entries"                                          |\
           cut -f 3 -d ' '                                                    |\
           cut -f 1 -d '-'                                                    ))

log_prefix="./"

log_filename="log-$( date +%Y%m%d%H%M ).txt"

log=${log_prefix}${log_filename}

# Note: zsh and bash differ in terms of the first index for arrays
for i in $( seq 0 $( bc <<< "$sanitized_entry_num-1" ))
do
    # let's be gentle with some museum routers:
    # we are effectively launching DoS to these craps
    sleep 10

    echo ${idx[$i]} ${proto[$i]} ${port[$i]} 2>&1 | tee -a $log | cat 1>&2
    upnpc -d ${port[$i]} ${proto[$i]} 2>&1 >> $log                           &&\
        echo OK | tee -a $log | cat 1>&2
    echo >> $log
done
