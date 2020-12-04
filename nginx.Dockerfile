FROM nginx
COPY ./nginx.conf /etc/nginx/conf.d/default.conf

COPY ./bundle /usr/share/nginx/html
