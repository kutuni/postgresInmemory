# postgresInmemory
postgresql data directory on auto created ramfs, inmemory postgres 

use make file 
simple using
make run

for pgbench

make createtables
make startTest



check other details in makeFile:
build:
	docker build --no-cache -t kutuni/postgresql-inmemory:10.5 .

shell:
	docker exec -it postgres bash

run:
	docker run --name postgres-inmemory \
	-e POSTGRES_PASSWORD=docker \
	-e POSTGRES_USER=postgres  \
	-e DISK_SIZE=3g  \
    --publish 50432:5432 \
	--restart always \
    --privileged \
    -d kutuni/postgresql-inmemory:10.5
    
    
if you change configuration should be mount as below
   -v $(PWD)/postgresql.conf:/postgresql.conf \

clean:
	docker rm -f postgres-inmemory

createtables:
	 docker exec -e SCALE=50 -it postgres-inmemory /createtables.sh

starttest:
	docker exec -e THREAD=32 -e CONNECTION=8 -e SCALE=50 -it postgres-inmemory /run.sh
