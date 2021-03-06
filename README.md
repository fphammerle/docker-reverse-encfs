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

## Docker Compose 🐙

1. Adapt paths in [docker-compose.yml](docker-compose.yml)
2. `docker-compose up`

## Password

A random password will be generated and stored in `/secret/password`.

Set the env var `$ENCFS_PASSWORD_LENGTH` to change its length.

## Access Encrypted Data

Add `-v /somewhere:/encrypted:shared` to mount the encrypted view of `/plain/*` into the host filesystem.

You may need to disable user namespace remapping for containers
(dockerd option `--userns-remap`)
due to https://github.com/moby/moby/issues/36472 .

## Serve Encrypted Data via Rsync SSH Server

See [examples/rsync-sshd](examples/rsync-sshd/docker-compose.yml)

Grant rsync access to a gpg-encrypted view of the encfs password:
[examples/rsync-sshd-incl-gpg-enc-pwd](examples/rsync-sshd-incl-gpg-enc-pwd/docker-compose.yml)

## Known Issues

Mount fails with `EPERM / Operation not permitted`
when enabling `--security-opt=no-new-privileges`.

`fusermount` must run with `uid=0`.
`no-new-privileges` makes the `setuid` bit ineffective:
```sh
$ stat -c '%A %U %G' /bin/fusermount
-rwsr-xr-x root root
```
