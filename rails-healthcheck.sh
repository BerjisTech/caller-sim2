#!/bin/bash

# Exit script on any error
set -e

# Check if database connection is available
bundle exec rake db:version > /dev/null 2>&1

# Check if there are any pending migrations
if bundle exec rake db:migrate:status | grep -q "down"; then
  bundle exec rake db:migrate
  echo "Migrations pending"
  exit 1
else
  echo "All migrations are up-to-date"
  exit 0
fi
