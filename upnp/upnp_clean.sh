#!/bin/bash

# Warning:      Back up what were there before runing this.
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

# Note: zsh and bash differ in terms of the first index for arrays
for i in $( seq 0 $( bc <<< "$sanitized_entry_num-1" ))
do
    echo ${idx[$i]} ${proto[$i]} ${port[$i]} 1>&2
    upnpc -d ${port[$i]} ${proto[$i]} 1>/dev/null 2>/dev/null && echo OK 1>&2
done
