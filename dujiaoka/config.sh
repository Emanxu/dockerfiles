#!/bin/bash
echo "现在开始设置你的 dujiaoka ，请按照步骤输入即可"

# 读取用户输入
read -p "请输入 MYSQL_ROOT_PASSWORD: " passwd_root
read -p "请输入 MYSQL_USER: " user
read -p "请输入 MYSQL_PASSWORD: " passwd_user


echo "现在开始设置你的 epusdt ，请按照步骤输入即可"
read -p "请输入 app_uri: " app_uri
read -p "请输入 tg_bot_token: " tg_bot_token
read -p "请输入 tg_manage: " tg_manage


# 设置为环境变量
export passwd_root=$passwd_root
export user=$user
export passwd_user=$passwd_user
export app_uri=$app_uri
export tg_bot_token=$tg_bot_token
export tg_manage=$tg_manage


# 注意格式，例如文件内 ${user} 在前面， 替换为后面的 $user环境变量的值
# 替换 dujiaoka 上的环境变量 --> env.conf
envsubst < env.conf.example > env.conf

# 替换 epusdt 上的环境变量 需要 sed --> epusdt.conf
envsubst < epusdt/epusdt.conf.example > epusdt.conf

echo "Done!!!"




