#!/bin/bash

# 启动: nohup bash ./nf.sh > /dev/null 2>&1 &
# 停止: ps aux | grep nf.sh | grep -v grep | awk '{print $2}' | xargs kill -9
IPv="4" # 使用 IPv4 还是 IPv6 检测
UA_Browser="Mozilla/5.0 (X11; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/116.0"
url="https://www.netflix.com/title/70143836" # Netflix 自制剧URL (絕命毒師)
check_nf() { curl -${IPv}fsL -A "${UA_Browser}" -w %{http_code} -o /dev/null -m 10 "${url}" 2>&1; }
# check_nf; # 200: unblock, 404: block

log="/root/ip.txt" # 日志文件
while true; do
  code=$(check_nf);
  # echo $code;
  if [ "$code" = "404" ]; then
    date +"%Y-%m-%d %H:%M:%S" >>$log
      不解锁时, 调用API自动更换IP
      curl http://xxx.com/change_ip >>$log
          curl -s "https://api.telegram.org/bot"API"/sendMessage" \
        -d "chat_id=ID" \
        -d "text=当前IP不解锁非自制剧，正在尝试换IP..."
  fi
  sleep $((60 * $interval)) # xx秒
done
