FROM nginx:1.13.1-alpine

COPY dist/automated-nginx-demo /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
