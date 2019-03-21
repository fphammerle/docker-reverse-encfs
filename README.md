# Reverse EncFS 🐳

Provides an EncFS-enciphered view `/encrypted` of volumes mounted at `/plain`

```sh
docker run --rm -it --device /dev/fuse \
    -v plain-data:/plain/data:ro \
    -v encfs-password:/secret \
    --cap-add SYS_ADMIN --security-opt apparmor:unconfined \
    fphammerle/reverse-encfs
```

Optionally add `-v encfs-config:/encrypted/config` to make `encfs6.xml` persistent.

Optionally add `--network none`

Or simply run `docker-compose up`
