#!/bin/bash

SITE=http://marc.info
OUTPUT_DIR=lkml

# usage: get_message <mid> <month> <output file>
function get_message() {
    MESSAGE_HTML=.message.html
    mid=$1
    month=$2

    html_url=$SITE/?m=$mid
    if ! curl -s $html_url -o $MESSAGE_HTML; then
	echo "Download message $mid failed"
	return 1;
    fi

    list=`grep -m 1 "^List:" $MESSAGE_HTML | grep -o ">.*<" | sed "1s/^.//" | sed "1s/.$//"`
    subject=`grep -m 1 "^Subject:" $MESSAGE_HTML | sed "s/Subject:    //g" | sed "s/<[^<>]*>//g"`
    date=`grep -m 1 "^Date:" $MESSAGE_HTML | grep -o ">.*<" | sed "1s/^.//" | sed "1s/.$//"`

    output=$3
    if [[ "$output" == "" ]]; then
	output=$OUTPUT_DIR/$month/`echo $subject | sed "s#/#|#g"`
    fi
    echo "List:       $list" > "$output"
    echo "Subject:    $subject" >> "$output"
    echo "Date:       $date" >> "$output"
    echo >> "$output"

    raw_message_url=$html_url"&q=raw"
    curl -s "$raw_message_url" >> "$output"

    rm $MESSAGE_HTML
}

# usage: get_thread <tid> <month>
function get_thread() {
    THREAD_HTML=.thread.html
    tid=$1

    html_url=$SITE/?t=$tid
    if ! curl -s $html_url -o $THREAD_HTML; then
	echo "Download thread $tid failed"
	return 1
    fi

    title=`grep -m 1 "^Viewing messages in thread" $THREAD_HTML | grep -o "'.*'" | sed "1s/^.//" | sed "1s/.$//" | sed "s#/#|#g"`
    mkdir -p "$OUTPUT_DIR/$month/$title"

    echo "Downloading:    $title"
    sid=1
    grep "href=" $THREAD_HTML | grep "m=" | while read url; do
	mid=`echo $url | grep -o "\".*m=[^\"]*\"" | grep -o "m=[0-9]*" | sed "s/[^0-9]*//g"`
	get_message $mid $month "$OUTPUT_DIR/$month/$title/$sid"
	sid=$((sid+1))
    done

    rm $THREAD_HTML
}

#usage get_month <list> <month>
function get_month() {
    MONTH_HTML=.month.html
    list=$1
    month=$2

    mkdir -p "$OUTPUT_DIR/$month"
    page=1
    done=0
    while [[ $done == 0 ]]; do
	html_url="$SITE/?l=$list&b=$month&r=$page"
	if ! curl -s $html_url -o $MONTH_HTML; then
    	    echo "Download $list-$month failed"
    	    return 1
	fi

	grep "href=" $MONTH_HTML | grep -E "(\?t|&m)=" | while read url; do
	    tid=`echo $url | grep -o "\".*t=[^\"]*\"" | grep -o "t=[0-9]*" | sed "s/[^0-9]*//g"`
	    if [[ "$tid" != "" ]]; then
		get_thread $tid $month
	    else
		mid=`echo $url | grep -o "\".*m=[^\"]*\"" | grep -o "m=[0-9]*" | sed "s/[^0-9]*//g"`
		get_message $mid $month
	    fi
	done

	if grep "arrright.gif" $MONTH_HTML; then
	    page=$((page+1))
	else
	    done=1
	fi
    done

    rm $MONTH_HTML
}

#usage get_list <list>
function get_list() {
    LIST_HTML=.list.html
    list=$1

    html_url="$SITE/?l=$list"
    if ! curl -s $html_url -o $LIST_HTML; then
    	echo "Download $list failed"
    	return 1
    fi

    grep "href=" $LIST_HTML | grep "&b=" | while read url; do
	month=`echo $url | grep -o "\".*b=[^\"]*\"" | grep -o "&b=[0-9]*" | sed "s/[^0-9]*//g"`
	get_month $list $month
    done

    rm $LIST_HTML
}

rm -rf lkml/*
get_list linux-kernel
