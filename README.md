```sh
# TODO remove --userns
# TODO add image name
docker run --rm -it --device /dev/fuse \
    -v plain-data:/plain/data \
    -v encfs-password:/secret \
    --cap-add SYS_ADMIN --security-opt apparmor:unconfined ?
```

Optionally add `-v encfs-config:/encrypted/config` to make `encfs6.xml` persistent.

Optionally add `--network none`
