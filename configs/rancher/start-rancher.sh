#!/usr/bin/bash


sleep ${pre-sleep}
mkdir -p $HOME/nginx/conf.d
wget http://kiloalpha.s3.amazonaws.com/nginx/rancher-ui-ssl.conf.py
python rancher-ui-ssl.conf.py ${name} ${domain} | \
    tee $HOME/nginx/conf.d/${name}.conf
docker run -d \
    --restart=unless-stopped \
    -p 8080:8080 \
    --name=${name} \
    rancher/server:stable
docker run -d \
    -p 80:80 -p 443:443 \
    -v $HOME/nginx/conf.d:/etc/nginx/conf.d \
    -v $HOME/certs:/etc/nginx/certs \
    -v $HOME/html:/usr/share/nginx/html \
    --link=${name} \
    --name=${name}-nginx \
    nginx
