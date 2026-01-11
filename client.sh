#!/bin/bash

SERVER_FIFO="/tmp/fifo_server"
CLIENT_FIFO="/tmp/fifo_$$" # $$ - PID 
COMMAND=$1 #command we want to know the man of

#echo "$CLIENT_FIFO"

clean_up() {
    rm "$CLIENT_FIFO"
    exit 0
}

trap 'clean_up' EXIT
#remove the fifo when stopping the process

REQUEST="BEGIN-REQ [$$: $COMMAND] END-REQ"
##echo "$REQUEST"

#sending the request to the fifo

if [[ ! -p "$SERVER_FIFO" ]]; then #test if the fifo exists
    echo "Bad server connection, try again"
    exit 1
fi

#send the request to the server

echo "$REQUEST" > "$SERVER_FIFO"

cnt=0
while [[ ! -p "$CLIENT_FIFO" ]]
do
    sleep 0.1
    ((cnt++)) ## wait max 1 second
    if [ "$cnt" -eq 10 ]; then
        echo "Server timeout"
        exit 1
    fi
done
## wait for server to create client fifo


if [[ -p "$CLIENT_FIFO" ]] then #test if the fifo exists
    cat $CLIENT_FIFO
fi
