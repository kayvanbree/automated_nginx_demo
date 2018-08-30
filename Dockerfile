FROM nginx:1.13.1-alpine

COPY dist/ /usr/share/nginx/html/angular
COPY default.conf /etc/nginx/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
