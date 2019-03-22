FROM alpine:3.9

RUN apk add --no-cache encfs

ENV ENCFS_PASSWORD_CHARSET="1-9a-km-zA-HJKLMNPR-Z*+!&#@%.\-_" \
    ENCFS_PASSWORD_LENGTH=32 \
    ENCFS_PASSWORD_PATH=/secret/password \
    ENCFS_SOURCE_DIR=/plain \
    ENCFS_TARGET_DIR=/encrypted

ENV ENCFS_MOUNT_POINT=$ENCFS_TARGET_DIR/encfs \
    ENCFS_CONFIG_COPY_PATH=$ENCFS_TARGET_DIR/encfs6.xml

COPY ./mount.sh /
RUN adduser -S encrypt \
    && mkdir -p \
        $(dirname $ENCFS_PASSWORD_PATH) \
        $ENCFS_SOURCE_DIR \
        $ENCFS_TARGET_DIR \
    && chown -c encrypt \
        $(dirname $ENCFS_PASSWORD_PATH) \
        $ENCFS_SOURCE_DIR `#.encfs6xml` \
        $ENCFS_TARGET_DIR \
    && echo user_allow_other >> /etc/fuse.conf \
    && chmod a+rx /mount.sh
USER encrypt
CMD ["/mount.sh"]
