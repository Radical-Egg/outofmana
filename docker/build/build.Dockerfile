FROM radicalegg/hugo:latest as build
ENV HUGO_ENVIRONMENT=production

WORKDIR /app
COPY ./src /app

RUN apk add git
RUN git submodule init; \
    git submodule update; \	
    hugo

FROM nginx:stable-alpine

WORKDIR /opt/outofmana

COPY --from=build /app/public/ /opt/outofmana/

EXPOSE 80/tcp
EXPOSE 443/tcp
