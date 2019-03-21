FROM alpine:3.9

RUN apk add --no-cache encfs

ENV ENCFS_PASSWORD_CHARSET="1-9a-km-zA-HJKLMNPR-Z*+!&#@%.\-_" \
    ENCFS_PASSWORD_LENGTH=32 \
    ENCFS_PASSWORD_PATH=/secret/password \
    ENCFS_SOURCE_DIR=/plain \
    ENCFS_MOUNT_POINT=/encrypted/encfs \
    ENCFS_CONFIG_PATH=/encrypted/config/encfs6.xml \
    ENCFS_CONFIG_GENERATION_TIMEOUT_SECS=8

COPY ./mount.sh /
RUN mkdir -p \
        $(dirname $ENCFS_PASSWORD_PATH) \
        $ENCFS_SOURCE_DIR \
        $ENCFS_MOUNT_POINT \
        $(dirname $ENCFS_CONFIG_PATH) \
    && chmod +x /mount.sh
# TODO run as unprivileged user
CMD ["/mount.sh"]
