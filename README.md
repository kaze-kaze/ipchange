# ipchange
动态IP VPS检测被墙自动换IP并通知telegram BOT
脚本介绍：通过ping itdog.cn检测IP是否被墙，是则换IP并通知Telegram

#NF check
通过检测奈飞绝命毒师判断是否掉解锁，是则自动换IP并通知Telegram bot
用法: 把下面的脚本保存为 nf.sh 文件, 调整里面 调用API自动更换IP 的部分, 加上调用自己的API地址.
启动脚本, 执行 nohup bash ./nf.sh > /dev/null 2>&1 & 即可;
停止脚本, 执行 ps aux | grep nf.sh | grep -v grep | awk '{print $2}' | xargs kill -9 即可.
使用场景: 当解锁失效时, 动态IP的vps, 通过API自动更换IP; 非动态IP的vps, 自动换配置/出口等.

ipv6 check脚本 
通过检测 选出分配的IPv6段下最适合你网络的IP（到目标ipv6延迟最低的IP）
