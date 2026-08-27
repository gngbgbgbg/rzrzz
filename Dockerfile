FROM alireza0/x-ui:latest

# نصب پیش‌نیازها و Nginx جهت پوشش ترافیک
RUN apt-get update && apt-get install -y nginx gettext-base curl bash

# تنظیم متغیرهای محیطی برای جلوگیری از تداخل پورت Render
ENV PORT=8080
ENV XUI_PORT=2053

# اسکریپت استارت مانیتورینگ و لایه امنیتی
RUN echo '#!/bin/bash\n\
sed -i "s/LISTENING_PORT/$PORT/g" /etc/nginx/sites-available/default\n\
service nginx start\n\
/app/x-ui\n\
' > /entrypoint.sh && chmod +x /entrypoint.sh

# پیکربندی Nginx برای عبور دادن ترافیک به شکل وب‌سایت عادی
RUN echo 'server {\n\
    listen LISTENING_PORT;\n\
    location / {\n\
        proxy_pass http://111.119.162.248:10909;\n\
        proxy_http_version 1.1;\n\
        proxy_set_header Upgrade $http_upgrade;\n\
        proxy_set_header Connection "upgrade";\n\
        proxy_set_header Host $host;\n\
    }\n\
}' > /etc/nginx/sites-available/default

EXPOSE 8080

ENTRYPOINT ["/entrypoint.sh"]
