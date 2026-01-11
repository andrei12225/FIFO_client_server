#!/bin/bash

SERVER_FILE="/tmp/fifo_server"

clean_up() {
    rm "$SERVER_FILE"
    echo "Server stopped"
    exit 0
}

trap 'clean_up' SIGINT

if [[ ! -p "$SERVER_FILE" ]] then
    mkfifo "$SERVER_FILE"
    echo "Server started, listening at $SERVER_FILE"
fi

while true; do
    if read line < "$SERVER_FILE"; then
        printf "\nRECEIVED: $line\n"

        regex="BEGIN-REQ \[([0-9]+): ([A-Za-z0-9_-]+)\] END-REQ"

        if [[ "$line" =~ $regex ]] then
            pid=${BASH_REMATCH[1]}
            command=${BASH_REMATCH[2]}
            
            echo "REQUEST IS VALID: PID: $pid  CMD: $command"

            CLIENT_FILE="/tmp/fifo_$pid"

            (
                if [[ -p "$CLIENT_FILE" ]] then
                    echo "FIFO ALREADY EXISTS FOR $pid, DOING NOTHING"
                else
                    mkfifo "$CLIENT_FILE"
                    echo "CREATED FIFO $CLIENT_FILE"

                    if man "$command" > /dev/null 2>/dev/null; then
                        man "$command" > "$CLIENT_FILE"
                    else
                        echo "No manual entry for $command." > "$CLIENT_FILE"
                    fi
                fi
            ) &
        fi
    fi
done