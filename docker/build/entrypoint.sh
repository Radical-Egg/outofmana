#!/bin/sh

if ! getent group $PGID >/dev/null 2>&1; then
    addgroup -g $PGID hugo
fi

if ! id -u $PUID >/dev/null 2>&1; then
    adduser -u $PUID -G hugo -D -s /bin/sh hugo
fi

chown -R $PUID:$PGID /app

/sbin/su-exec hugo "$@"
