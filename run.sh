#!/bin/bash

export PGDATABASE=postgres
export PGUSER=${POSTGRES_USER}
export PGPASSWORD=${POSTGRES_PASSWORD}
export PGHOST=localhost
export PGPORT=5432

echo '*************** Waiting for postgres ***************'
echo '**                                                **'
echo "** PGDATABASE: ${PGDATABASE}                      **"
echo "** PGHOST:     ${PGHOST}                          **"
echo "** PGPORT:     ${PGPORT}                          **"
echo "** PGUSER:     ${PGUSER}                          **"
echo '**                                                **'
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


echo '***************   Running pgbench    ***************'

for run in 1 2 3; do
  echo Starting run $run
  pgbench -c $(($CONNECTION)) -j $THREAD -M prepared -s $SCALE -T 300
  echo
  echo
done
