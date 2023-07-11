FROM nastools/nas-tools:latest

RUN set -x && \
    apk add --no-cache nginx php-fpm php-curl && \
    rm -f /etc/nginx/http.d/default.conf && \
    mkdir -p /douban && \
    mkdir -p /etc/services.d/nginx && \
    mkdir -p /etc/services.d/php-fpm && \
    cp /etc/services.d/NAStool/notification-fd /etc/services.d/php-fpm/notification-fd && \
    cp /etc/services.d/NAStool/notification-fd /etc/services.d/nginx/notification-fd

COPY 030-fixdouban /etc/cont-init.d/
COPY douban.php /douban/
COPY douban.conf /etc/nginx/http.d/
COPY nginx_run /etc/services.d/nginx/run
COPY nginx_finish /etc/services.d/nginx/finish
COPY php_run /etc/services.d/php-fpm/run
COPY php_finish /etc/services.d/php-fpm/finish

RUN chmod +x /etc/cont-init.d/030-fixdouban && \
    chmod +x /etc/services.d/nginx/* && \
    chmod +x /etc/services.d/php-fpm/*
