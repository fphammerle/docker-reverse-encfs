```sh
# TODO remove --privileged
# TODO remoge --userns
# TODO add image name
docker run --rm -it \
    -v plain-data:/source/plain \
    -v encfs-password:/source/secret \
    --device /dev/fuse --privileged --userns host ?
```

Optionally add `-v encfs-config:/target/config` to make `encfs6.xml` persistent.
