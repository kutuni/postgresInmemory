#!/bin/bash


function initialize_pgbench_tables() {
  echo 'Initializing pgbench tables Scale Factor is $SCALE'
  pgbench -i -s $SCALE --foreign-keys --unlogged-tables --no-vacuum
  echo '1 factor is 100000 records'
}

export PGDATABASE=postgres
export PGUSER=${POSTGRES_USER}
export PGPASSWORD=${POSTGRES_PASSWORD}
export PGHOST=localhost
export PGPORT=5432

echo '*************** Waiting for postgres ***************'
echo '**                                                '
echo "** PGDATABASE: ${PGDATABASE}                      "
echo "** PGHOST:     ${PGHOST}                          "
echo "** PGPORT:     ${PGPORT}                          "
echo "** PGUSER:     ${PGUSER}                          "
echo '**                                                '
echo '****************************************************'

attempt=1
while (! pg_isready -t 1 ) && [[ $attempt -lt 100 ]]; do
  sleep 1
done

if [[ $attempt -ge 100 ]]; then
  echo '!!!!                                          !!!!'
  echo '!!!!             BENCHMARK FAILED             !!!!'
  echo '!!!!                                          !!!!'
  echo '!!!!      postgres never became available     !!!!'
  echo '!!!!                                          !!!!'
  exit 1
fi

initialize_pgbench_tables

if [[ $? -ne 0 ]]; then
  exit $?
fi
