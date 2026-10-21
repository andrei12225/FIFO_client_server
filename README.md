# FIFO Client-Server

A small Bash-based client/server application that communicates through named pipes (FIFO files) on Linux-like systems.

The server listens for requests on a shared FIFO and, for each valid request, looks up the requested command's manual page via `man` and sends it back to the client through a per-client FIFO.

## Project files

- `server.sh` - creates and listens on the server FIFO, validates requests, and responds to clients.
- `client.sh` - sends a request to the server and waits for the server's response.

## How it works

1. The server creates `/tmp/fifo_server` if it does not already exist.
2. A client sends a request in the format:
   `BEGIN-REQ [PID: COMMAND] END-REQ`
3. The server validates the request, creates a response FIFO named `/tmp/fifo_<pid>`, and writes the command's `man` page content to it.
4. The client waits until that FIFO appears, then reads and prints the response.

## Requirements

- Bash
- `mkfifo`
- `man`
- A Unix-like environment with support for named pipes

## Usage

Start the server in one terminal:

```bash
./server.sh
```

Then, in another terminal, request a manual page:

```bash
./client.sh ls
```

Example output:

```text
Server started, listening at /tmp/fifo_server
REQUEST IS VALID: PID: 12345  CMD: ls
```

Client output:

```text
LS(1)                            User Commands                           LS(1)
...
```

If the command does not have a manual page, the server returns a message like:

```text
No manual entry for <command>.
```

## Notes

- The server runs until interrupted with `Ctrl+C`.
- FIFOs are created under `/tmp`.
- The project is intentionally lightweight and demonstrates basic inter-process communication using Unix FIFOs.

## Example

```bash
./server.sh
./client.sh grep
./client.sh git
```

This project is useful for learning about Linux IPC, shell scripting, and POSIX named pipes.
