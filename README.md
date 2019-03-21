```sh
# TODO remove --privileged
# TODO remoge --userns
# TODO add image name
docker run --rm -it \
    -v plain-data:/plain/data \
    -v encfs-password:/secret \
    --device /dev/fuse --privileged --userns host ?
```

Optionally add `-v encfs-config:/encrypted/config` to make `encfs6.xml` persistent.

Optionally add `--network none`
