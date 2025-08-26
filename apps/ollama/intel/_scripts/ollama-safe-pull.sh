#!/usr/bin/env bash

set -e

echo "Starting Temporary Ollama Server..."
/bin/ollama serve > /dev/null 2> /dev/null &
_OLLAMA_PID=$!

while true
do
    /bin/ollama list > /dev/null 2> /dev/null && break || echo "Waiting Temporary Ollama Server..."
	sleep 1
done

/bin/ollama pull "$@"

kill -SIGTERM $_OLLAMA_PID

wait $_OLLAMA_PID
