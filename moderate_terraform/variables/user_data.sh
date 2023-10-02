#!/bin/bash
sudo dnf --assumeyes update
sudo dnf --assumeyes upgrade
sudo dnf install -y epel-release

### Install Firewalld ###
sudo dnf --assumeyes install firewalld
sudo systemctl start firewalld
sudo systemctl enable firewalld
sudo firewall-cmd --zone=public --permanent --add-service=ssh
sudo firewall-cmd --zone=public --permanent --add-service=http
sudo firewall-cmd --zone=public --permanent --add-service=https
sudo systemctl reload firewalld

### Intall Nginx ###
sudo dnf module enable nginx:mainline
sudo dnf --assumeyes install nginx
sudo systemctl enable --now nginx

### Configure Nginx ###
sudo mv /usr/share/nginx/html/index.html index.html.bak
sudo touch /usr/share/nginx/html/index.html
sudo chown -R  nginx:nginx /usr/share/nginx/
sudo mkdir /etc/pki/nginx/
sudo chown -R  nginx:nginx /usr/share/nginx/
sudo cat > /usr/share/nginx/html/index.html << EOF1
<html>
    <head>
        <title>Welcome to Intro to Terraform on Azure!</title>
    </head>
    <body><font size="20"> 
        <p>Welcome to Intro to Terraform on Azure!</b>!</p>
        </font> 
    </body>
</html>
EOF1

#######################
### Configure Nginx ###
#######################
sudo mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak
sudo cat > /etc/nginx/nginx.conf << EOF2
worker_processes auto;
error_log /var/log/nginx/error.log;
pid /run/nginx.pid;

# Load dynamic modules. See /usr/share/doc/nginx/README.dynamic.
include /usr/share/nginx/modules/*.conf;

events {
    worker_connections 1024;
}

http {
    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    sendfile            on;
    tcp_nopush          on;
    tcp_nodelay         on;
    keepalive_timeout   65;
    types_hash_max_size 4096;

    include             /etc/nginx/mime.types;
    default_type        application/octet-stream;

    # Load modular configuration files from the /etc/nginx/conf.d directory.
    # See http://nginx.org/en/docs/ngx_core_module.html#include
    # for more information.
    include /etc/nginx/conf.d/*.conf;

    server {
        listen       80;
        listen       [::]:80;
        server_name  _;
        root         /usr/share/nginx/html;

        # Load configuration files for the default server block.
        include /etc/nginx/default.d/*.conf;

        error_page 404 /404.html;
        location = /404.html {
        }

        error_page 500 502 503 504 /50x.html;
        location = /50x.html {
        }
    }

# Settings for a TLS enabled server.
#
   server {
       listen       443 ssl http2;
       listen       [::]:443 ssl http2;
       server_name  terraform.energy.gov;
       root         /usr/share/nginx/html;

       ssl_certificate "/etc/pki/nginx/server.crt";
       ssl_certificate_key "/etc/pki/nginx/private/server.key";
       ssl_session_cache shared:SSL:1m;
       ssl_session_timeout  10m;
       ssl_protocols TLSv1.3;
       ssl_ciphers HIGH;
       ssl_prefer_server_ciphers on;

       # Load configuration files for the default server block.
       include /etc/nginx/default.d/*.conf;

       error_page 404 /404.html;
           location = /40x.html {
       }

       error_page 500 502 503 504 /50x.html;
           location = /50x.html {
       }
   }

}
EOF2

sudo cat > ~/server_rootCA.csr.cnf << EOF3
# server_rootCA.csr.cnf
[req]
default_bits = 2048
prompt = no
default_md = sha256
distinguished_name = dn

[dn]
C=US
ST=Virginia
L=Germantown
O=doe
OU=local_RootCA
emailAddress=ikke@server.germantown
CN = terraform.energy.gov
EOF3

sudo mkdir /etc/pki/nginx/private/
sudo openssl req -new -sha256 -nodes -out /etc/pki/nginx/server.csr -newkey rsa:2048 -keyout /etc/pki/nginx/private/server.key -config ~/server_rootCA.csr.cnf  
sudo openssl x509 -signkey /etc/pki/nginx/private/server.key -in /etc/pki/nginx/server.csr -req -days 365 -out /etc/pki/nginx/server.crt
sudo chown -R  nginx:nginx /usr/share/nginx/
sudo chown -R  nginx:nginx /etc/pki/nginx/
sudo systemctl restart nginx
