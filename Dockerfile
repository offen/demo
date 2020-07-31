FROM nginx:1.19-alpine

COPY demo.sh /usr/share/nginx/html

RUN rm /etc/nginx/conf.d/default.conf
COPY demo.offen.dev.conf /etc/nginx/conf.d/demo.offen.dev.conf
