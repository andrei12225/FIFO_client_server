#!/bin/bash

SERVER_FIFO="/tmp/fifo_server"
CLIENT_FIFO="/tmp/fifo$$" # $$ - PID 
COMMAND=$1 #command we want to know the man of

#echo "$CLIENT_FIFO"

clean_up() {
    rm "$CLIENT_FIFO"
    exit 0
}

trap 'clean_up' SIGINT
#remove the fifo when stopping the process

REQUEST="BEGIN-REQ[$$:$COMMAND]END-REQ"
##echo "$REQUEST"

#sending the request to the fifo

if [[ ! -p "$SERVER_FIFO" ]] then #test if the fifo exists
    echo "Bad server connection, try again"
    exit
fi

