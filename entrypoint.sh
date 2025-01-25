#!/bin/bash
set -e

# Wait for the db to be ready
# until PGPASSWORD=$POSTGRES_PASSWORD psql -h "db" -U "$POSTGRES_USER" -c '\q'; do
#   echo "Postgres is unavailable - sleeping"
#   sleep 1
# done

# echo "Postgres is up - executing command"

# If the database exists, migrate. Otherwise setup (create and migrate)
bundle exec rake db:migrate || bundle exec rake db:setup

# Remove a potentially pre-existing server.pid for Rails.
rm -f /usr/src/app/tmp/pids/server.pid

#  Start the serveron port 3008
bundle exec rails s -p 3008 -b '0.0.0.0'

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"