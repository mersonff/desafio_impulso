#!/bin/bash

echo "🚀 Starting Sidekiq worker container..."
echo "Environment: $RAILS_ENV"
echo "Redis URL: $REDIS_URL"

# Test Redis connectivity
if [ -n "$REDIS_URL" ]; then
  echo "🔴 Testing Redis connectivity..."
  bundle exec rails runner "puts 'Redis test: ' + Redis.new(url: ENV['REDIS_URL']).ping rescue 'Failed'" || echo "⚠️ Redis test failed"
else
  echo "⚠️ REDIS_URL not set"
fi

# Start a simple HTTP server for health checks in background
echo "🏥 Starting health check server on port 8080..."
(while true; do
  echo -e "HTTP/1.1 200 OK\nContent-Length: 2\n\nOK" | nc -l -p 8080 -q 1
done) &

echo "💼 Starting Sidekiq worker with 5 threads..."
# Start Sidekiq in foreground with verbose logging
bundle exec sidekiq -c 5 -v