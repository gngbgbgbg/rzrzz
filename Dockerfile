FROM alireza0/x-ui:latest

# نصب Nginx
RUN apt-get update && apt-get install -y nginx curl bash

# تعریف پورت داخلی 3x-ui
ENV XUI_PORT=2053

# ساخت کانفیگ Nginx و جایگزینی پورت
RUN echo 'server {\n\
    listen $PORT;\n\
    location / {\n\
        proxy_pass http://111.119.162.248:2053;\n\
        proxy_http_version 1.1;\n\
        proxy_set_header Upgrade $http_upgrade;\n\
        proxy_set_header Connection "upgrade";\n\
        proxy_set_header Host $host;\n\
    }\n\
}' > /etc/nginx/sites-available/default

# اسکریپت اجرا
RUN echo '#!/bin/bash\n\
sed -i "s/\$PORT/$PORT/g" /etc/nginx/sites-available/default\n\
service nginx start\n\
/app/x-ui\n\
' > /entrypoint.sh && chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
