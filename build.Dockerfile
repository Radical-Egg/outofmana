FROM radical-egg/hugo:latest as build
ENV HUGO_ENVIRONMENT=production

WORKDIR /app
COPY ./src /app

RUN hugo

FROM nginx:stable-alpine

WORKDIR /usr/share/nginx/html

COPY --from=build /app/public/ .
COPY ./docker/configs/outofmana.conf /etc/nginx/conf.d/default.conf

EXPOSE 80/tcp
EXPOSE 443/tcp
