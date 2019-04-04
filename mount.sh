#!/bin/sh
set -e

ENCFS_SOURCE_CONFIG_PATH="$ENCFS_SOURCE_DIR/.encfs6.xml"

if [ ! -f "$ENCFS_PASSWORD_PATH" ]; then
    echo generating encfs password at $ENCFS_PASSWORD_PATH
    (set -x;
     tr -dc "$ENCFS_PASSWORD_CHARSET" < /dev/random | head -c "$ENCFS_PASSWORD_LENGTH" > "$ENCFS_PASSWORD_PATH")
    [ -f "$ENCFS_SOURCE_CONFIG_PATH" ] && (set -x; rm "$ENCFS_SOURCE_CONFIG_PATH")
fi

# cave: when $ENCFS6_CONFIG is set, encfs excepts the config to already exist
# ERROR fatal: config file specified by environment does not exist: /target/config/encfs6.xml [FileUtils.cpp:246]
# https://github.com/vgough/encfs/issues/497

function copy_config {
    sleep 4
    while [ ! -f "$ENCFS_SOURCE_CONFIG_PATH" ]; do
        echo waiting for encfs to create $ENCFS_SOURCE_CONFIG_PATH
        sleep 2
    done
    (set -x; cp "$ENCFS_SOURCE_CONFIG_PATH" "$ENCFS_CONFIG_COPY_PATH")
}

copy_config &
set -x
mkdir -p "$ENCFS_MOUNT_POINT"
trap 'fusermount -u -z "$ENCFS_MOUNT_POINT"' SIGTERM
encfs -f -o allow_other --reverse --standard \
    --extpass="cat \"$ENCFS_PASSWORD_PATH\"" \
    "$ENCFS_SOURCE_DIR" "$ENCFS_MOUNT_POINT" &
wait $!
