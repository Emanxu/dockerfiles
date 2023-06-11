1. Build image & deploy
``` bash
docker build -t vmq .

docker-compose up -d
```

2. Change database passwd
``` bash
docker exec -it vmq bash

vim /app/vmqphp/config/database.php
```

3. Copy vmq.sql and import
``` bash
docker cp <vmq-ID>:/app/vmqphp/vmq.sql .

docker exec -i <db-ID> sh -c 'exec mysql -u<USER> -p<PASSWD> vmq' < vmq.sql
```

4. Setting your vmq
``` bash
# 测试支付页面：http://服务器域名/example/

# 如果需要使用测试代码，请设置main.php,notify.php,return.php里面的$key为你的通讯密钥

# 设置后台的同步回调地址为：http://服务器域名/example/return.php

# 设置后台的异步回调地址为：http://服务器域名/example/notify.php
```

#### 注意事项
PHP5.6 - 7.3 不支持7.4
mysql-5.6 MariaDB-10.11.2
nginx-1.18
伪静态要设置好为thinkphp
``` 
location / {
	if (!-e $request_filename){
		rewrite  ^(.*)$  /index.php?s=$1  last;   break;
	}
}
```
网站目录->运行目录 设置为public并保存
默认文档 设置将index.html放在第一行并保存
导入数据库文件（位于根目录）vmq.sql到您的数据库
默认后台账号和密码均为admin
如二维码无法正常识别，请给/public/qr-code/test.php设置777权限
项目目录权限跟随 php.ini 一致为 755

监控APP https://github.com/shinian-a/Vmq-App




