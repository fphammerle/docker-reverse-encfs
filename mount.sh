#!/bin/sh
set -e

if [ ! -f "$ENCFS_PASSWORD_PATH" ]; then
    echo generating encfs password
    (set -x;
     tr -dc "$ENCFS_PASSWORD_CHARSET" < /dev/random | head -c "$ENCFS_PASSWORD_LENGTH" > "$ENCFS_PASSWORD_PATH")
    [ -f "$ENCFS_CONFIG_PATH" ] && (set -x; rm "$ENCFS_CONFIG_PATH")
fi

function mount_encfs {
    (set -x
     encfs --reverse "$@" \
        --extpass="cat \"$ENCFS_PASSWORD_PATH\"" \
        "$ENCFS_SOURCE_DIR" "$ENCFS_MOUNT_POINT")
}

if [ ! -f "$ENCFS_CONFIG_PATH" ]; then
    # ERROR fatal: config file specified by environment does not exist: /target/config/encfs6.xml [FileUtils.cpp:246]
    # https://github.com/vgough/encfs/issues/497
    echo generating encfs config
    ENCFS_DEFAULT_CONFIG_PATH="$ENCFS_SOURCE_DIR/.encfs6.xml"
    if [ -f "$ENCFS_DEFAULT_CONFIG_PATH" ]; then
        echo conflicting encfs config in $ENCFS_DEFAULT_CONFIG_PATH
        exit 1
    fi
    mount_encfs --standard
    while [ ! -f "$ENCFS_DEFAULT_CONFIG_PATH" ]; do
        sleep 1
        echo waiting for encfs config
    done
    if [ -f "$ENCFS_DEFAULT_CONFIG_PATH" ]; then
        fusermount -u "$ENCFS_MOUNT_POINT"
        while mountpoint -q "$ENCFS_MOUNT_POINT"; do
            echo waiting for unmount
            sleep 1
        done
        (set -x; mv "$ENCFS_DEFAULT_CONFIG_PATH" "$ENCFS_CONFIG_PATH")
    else
        echo failed to generate encfs config
        exit 1
    fi
fi

export ENCFS6_CONFIG="$ENCFS_CONFIG_PATH"
# TODO grant access to other users / containers (--public / -o allow_other)
mount_encfs -f
