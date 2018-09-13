mkdir -p /data
mount -t ramfs -o size=$DISK_SIZE ramfs /data
sleep 1
chown postgres:postgres /data
chmod 700 /data
echo created ramfs `whoami` size: $DISK_SIZE

if [ -f /postgresql.conf ]; then
    cp /postgresql.conf /postgres.conf
    chown postgres:postgres /postgres.conf
    echo change own postgresql.conf
fi

