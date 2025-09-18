#!/bin/bash

# Start a simple HTTP server for health checks in background
(while true; do
  echo -e "HTTP/1.1 200 OK\nContent-Length: 2\n\nOK" | nc -l -p 8080 -q 1
done) &

# Start Sidekiq in foreground
bundle exec sidekiq -c 5