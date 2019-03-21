```sh
# TODO remove --privileged
# TODO remoge --userns
# TODO add image name
docker run --rm -it -v plain-data:/source/plain \
    --device /dev/fuse --privileged --userns host ?
```
