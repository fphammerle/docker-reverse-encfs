# Reverse EncFS 🐳

Provides an EncFS-enciphered view `/encrypted` of volumes mounted in `/plain`

```sh
docker run --rm --device /dev/fuse \
    -v plain-data1:/plain/foo:ro \
    -v plain-data2:/plain/bar:ro \
    -v encfs-password:/secret \
    --cap-add SYS_ADMIN --security-opt apparmor:unconfined \
    fphammerle/reverse-encfs
```

Optionally add `--network none`

Or simply run `docker-compose up`

## Password

A random password will be generated and stored in `/secret/password`.

Set the env var `$ENCFS_PASSWORD_LENGTH` to change its length.

## Access encrypted data

Add `-v /somewhere:/encrypted:shared` to mount the encrypted view of `/plain/*` into the host filesystem.

You may need to disable user namespace remapping for containers
(dockerd option `--userns-remap`)
due to https://github.com/moby/moby/issues/36472 .
