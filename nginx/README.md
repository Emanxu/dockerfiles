### 快速部署的 nginx 环境，docker使用的是 host 模式，直接使用宿主机的网络。

#### 目录配置
``` bash
# ~/nginx/conf 用于存放nginx 主配置文件
# ~/nginx/vhost 用于存放各站点conf配置文件
# ~/nginx/ssl 用于存放证书文件
# ~/nginx/html 用于存放网页文件

```

#### 完成准备工作
``` bash
# 将常用的域名证书上传至~/nginx/ssl
# 将网站的域名conf或者常用样本conf上传至~/nginx/vhost
# 将网页文件以各域名命名的文件夹上传至~/nginx/html
# 将整个nginx目录打包存档,上传至网盘,对象存储或者GitHub中.

# 证书路径 /etc/nginx/ssl/www.yourdomain.com.cer(key)
# 网站 root 路径 /usr/share/nginx/html/www.yourdomain.com

# 快速部署
# 在新环境需要使用时,直接通过wget或git clone将nginx目录拉取到服务器的/root下,执行以下命令启动容器,即可快速部署网站.使用过程中新增网站仅需上传网页文件和新建站点conf文件并重启容器.
docker run -d --name=nginx --restart=always \
    --network host \
    -v ~/nginx/conf/nginx.conf:/etc/nginx/nginx.conf \
    -v ~/nginx/vhost:/etc/nginx/conf.d/vhost \
    -v ~/nginx/ssl:/etc/nginx/ssl \
    -v ~/nginx/html:/usr/share/nginx/html \
    nginx


```

#### 注意事项
``` bash
# 使用 --network host
# 使用--network host参数是让nginx直接使用宿主机服务器的的网络,也就无需映射80/443端口.其目的是当有其他容器需要被nginx反向代理时,conf配置文件中的反代地址127.0.0.1能正确的被识别为宿主机.

# 不使用 --network host
# 如果不使用 --network host,而单独映射80/443端口到宿主机,当反向代理到127.0.0.1:XXXX的其他容器时是无法成功的.因为此时的127.0.0.1实际上是nginx这个容器自身的内网IP,并非宿主机的内网IP.

# 当然可以使用ifconfig -a命令查询宿主机的内网IP,替换掉127.0.0.1也能够解决.还有可以使用host.docker.internal来使容器识别宿主机IP,但是都相对麻烦,也不利于快速部署和迁移.大家可根据自己实际情况选择使用.

# 特殊需求
如果遇到环境中80/443端口被占用,临时需要使用nginx,同样可以使用以下映射端口的命令来启动,只是切记在反代时使用宿主机的内网IP.

docker run -d --name=nginx --restart=always \
    -p 8080:80 \
    -p 4443:443 \
    -v ~/nginx/conf/nginx.conf:/etc/nginx/nginx.conf \
    -v ~/nginx/vhost:/etc/nginx/conf.d/vhost \
    -v ~/nginx/ssl:/etc/nginx/ssl \
    -v ~/nginx/html:/usr/share/nginx/html \
    nginx
```

#### 进阶玩法
更进阶的玩法还可以将nginx,php,mysql整合成docker compose的方式来快速部署,网上已有成熟的方案,博主也在使用.推荐给大家:
https://github.com/yeszao/dnmp

#### nginx 常规样本
``` json
server
    {
        listen 80;
        #listen [::]:80;
        server_name www.yourdomain.com ;
        index index.html index.htm index.php default.html default.htm default.php;
        root  /usr/share/nginx/html/www.yourdomain.com;

        # return 301 https://www.yourdomain.com$request_uri;

        #error_page   404   /404.html;

        # Deny access to PHP files in specific directory
        #location ~ /(wp-content|uploads|wp-includes|images)/.*\.php$ { deny all; }

        location ~ .*\.(gif|jpg|jpeg|png|bmp|swf)$
        {
            expires      30d;
        }

        location ~ .*\.(js|css)?$
        {
            expires      12h;
        }

        location ~ /.well-known {
            allow all;
        }

        location ~ /\.
        {
            deny all;
        }

        access_log off;
    }

server
    {
        listen 443 ssl http2;
        #listen [::]:443 ssl http2;
        server_name www.yourdomain.com ;
        index index.html index.htm index.php default.html default.htm default.php;
        root  /usr/share/nginx/html/www.yourdomain.com;

#        if ($host = 'yourdomain.com') {
#            return 301 https://www.yourdomain.com$request_uri;
#        }

        ssl_certificate /etc/nginx/ssl/yourdomain.com.cer;
        ssl_certificate_key /etc/nginx/ssl/yourdomain.com.key;
        ssl_session_timeout 5m;
        ssl_protocols TLSv1 TLSv1.1 TLSv1.2 TLSv1.3;
        ssl_prefer_server_ciphers on;
        ssl_ciphers "TLS13-AES-256-GCM-SHA384:TLS13-CHACHA20-POLY1305-SHA256:TLS13-AES-128-GCM-SHA256:TLS13-AES-128-CCM-8-SHA256:TLS13-AES-128-CCM-SHA256:EECDH+CHACHA20:EECDH+CHACHA20-draft:EECDH+AES128:RSA+AES128:EECDH+AES256:RSA+AES256:EECDH+3DES:RSA+3DES:!MD5";
        ssl_session_cache builtin:1000 shared:SSL:10m;
        # openssl dhparam -out /usr/local/nginx/conf/ssl/dhparam.pem 2048
        # ssl_dhparam /usr/local/nginx/conf/ssl/dhparam.pem;

        #error_page   404   /404.html;

        # Deny access to PHP files in specific directory
        #location ~ /(wp-content|uploads|wp-includes|images)/.*\.php$ { deny all; }

        location ~ .*\.(gif|jpg|jpeg|png|bmp|swf)$
        {
            expires      30d;
        }

        location ~ .*\.(js|css)?$
        {
            expires      12h;
        }

        location ~ /.well-known {
            allow all;
        }

        location ~ /\.
        {
            deny all;
        }

        access_log off;
    }
```

#### Nginx 反向代理其他容器样本
``` json
upstream dockername { 
    server 127.0.0.1:8080; # 端口改为docker容器提供的端口
}

server {
    listen 80;
    server_name  www.domain.com;
    return 301 https://www.domain.com$request_uri;
}

server {
    listen 443 ssl;
    server_name  www.domain.com;
    gzip on;    

    ssl_certificate /etc/nginx/ssl/www.domain.com.cer;
    ssl_certificate_key /etc/nginx/ssl/www.domain.com.key;

    # access_log /var/log/nginx/dockername_access.log combined;
    # error_log  /var/log/nginx/dockername_error.log;

    location / {
        proxy_redirect off;
        proxy_pass http://dockername;

        proxy_set_header  Host                $http_host;
        proxy_set_header  X-Real-IP           $remote_addr;
        proxy_set_header  X-Forwarded-Ssl     on;
        proxy_set_header  X-Forwarded-For     $proxy_add_x_forwarded_for;
        proxy_set_header  X-Forwarded-Proto   $scheme;
        proxy_set_header  X-Frame-Options     SAMEORIGIN;

        client_max_body_size        100m;
        client_body_buffer_size     128k;
        
        proxy_buffer_size           4k;
        proxy_buffers               4 32k;
        proxy_busy_buffers_size     64k;
        proxy_temp_file_write_size  64k;
    }
}
```
