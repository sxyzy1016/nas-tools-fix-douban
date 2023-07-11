FROM nastools/nas-tools:latest

RUN set -x && \
    apk add --no-cache nginx php-fpm php-curl && \
    rm -f /etc/nginx/http.d/default.conf && \
    sed -i 's|worker_processes|#&|' /etc/nginx/nginx.conf && \
    sed -i 's|${card.image}|${"127.0.0.1:7777/douban.php?link=" +card.image}|' \
        /nas-tools/web/static/components/page/discovery/index.js && \
    mkdir -p /douban && \
    mkdir -p /etc/services.d/nginx && \
    mkdir -p /etc/services.d/php-fpm && \
    cp /etc/services.d/NAStool/notification-fd /etc/services.d/php-fpm/notification-fd && \
    cp /etc/services.d/NAStool/notification-fd /etc/services.d/nginx/notification-fd

COPY douban.php /douban/
COPY douban.conf /etc/nginx/http.d/
COPY nginx_run /etc/services.d/nginx/run
COPY nginx_finish /etc/services.d/nginx/finish
COPY php_run /etc/services.d/php-fpm/run
COPY php_finish /etc/services.d/php-fpm/finish

RUN chmod +x /etc/services.d/nginx/* && \
    chmod +x /etc/services.d/php-fpm/*
