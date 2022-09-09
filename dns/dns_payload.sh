#!/bin/bash

domain=$1

dns_id() {
    # See RFC 8484 section 4.1
    printf "\x00\x00"
}

dns_flag() {
    # Standard query
    printf "\x01\x00"
}

dns_questions() {
    # TODO for now hard coded to one
    printf "\x00\x01"
}

dns_answer_rrs() {
    # All zeros for query messages
    printf "\x00\x00"
}

dns_authority_rrs() {
    # All zeros for query messages
    printf "\x00\x00"
}

dns_addtional_rrs() {
    # All zeros for query messages
    printf "\x00\x00"
}

dns_query_name() {
    domain=$1
    levels=$( tr '.' '\n' <<< $domain )
    for l in $levels
    do
        len=${#l}
        len_hex=$( printf "%02x" $len )
        printf "\x${len_hex}"
        printf $l
    done
    printf '\0'
}

dns_query_type() {
    # Type A
    printf "\x00\x01"
}

dns_query_class() {
    # Internet addresses
    printf "\x00\x01"
}

dns_queries() {
    domain=$1
    dns_query_name $domain
    dns_query_type
    dns_query_class
}

dns_id
dns_flag
dns_questions
dns_answer_rrs
dns_authority_rrs
dns_addtional_rrs
dns_queries $domain
