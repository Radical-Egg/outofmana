FROM alpine:latest AS build

RUN apk add --no-cache go \
    gcc \
    g++ \
    su-exec
ENV CGO_ENABLED=1
ENV GOBIN="/app"

WORKDIR /app

RUN go install -tags extended,withdeploy github.com/gohugoio/hugo@latest

FROM alpine:latest
ENV PUID=1000
ENV PGID=1000
ENV HUGO_CACHEDIR=/tmp
ENV HUGO_EDITION=extended
ENV NODE_PATH=.:/usr/lib/node_module
ENV HUGO_ENVIRONMENT=production
ENV HUGO_BIND_ADDRESS=0.0.0.0

RUN apk add --no-cache libstdc++

WORKDIR /app

COPY --from=build /app/hugo /usr/local/bin/hugo
COPY --from=build /sbin/su-exec /sbin/su-exec


COPY ./docker/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]
CMD [ "/usr/local/bin/hugo", "server", "--bind=$HUGO_BIND_ADDRESS"]
