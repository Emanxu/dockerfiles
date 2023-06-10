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




