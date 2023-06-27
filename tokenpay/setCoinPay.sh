docker cp ./plugs <docker_dujiaoka_id>:/

docker exec -it <docker_dujiaoka_id> bash

cp /plugs/TokenPayController.php /dujiaoka/app/Http/Controllers/Pay/TokenPayController.php

cp /plugs/pay.php /dujiaoka/routes/common/pay.php

