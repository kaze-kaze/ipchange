#!/bin/bash

# 获取IP地址
ip_address=$(curl -s ifconfig.me)

# 执行ping命令，并检查结果
if ping -c 5 -W 2 -i 0.2 www.itdog.cn | grep "100% packet loss" > /dev/null
then
    echo "当前IP已经被封锁，正在尝试换IP..."
    # 向Telegram Bot发送消息
    curl -s "https://api.telegram.org/bot"此处填入BOT HTTP API，并删掉两边引号"/sendMessage" \
        -d "chat_id=你的chat ID" \
        -d "text=当前IP已经被封锁，正在尝试换IP..."
    
    # 执行换IP的命令
    curl http://ip更换API
    
    echo "IP已经更换完成。"
else
    echo "当前IP未被封锁"
fi
