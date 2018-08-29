FROM nginx:1.13.1-alpine

EXPOSE 80

COPY dist /var/www
COPY default.conf /etc/nginx/default.conf
