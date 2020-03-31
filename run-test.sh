#!/bin/bash

# Wait until Postgres is ready
while ! pg_isready -q -h $PGHOST -p $PGPORT -U $PGUSER
do
  echo "$(date) - waiting for database to start"
  sleep 2
done

mix deps.get
cd deps/argon2_elixir && make clean && make
cd ../..
exec mix test