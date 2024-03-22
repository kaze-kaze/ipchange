#!/bin/bash

ping_ipv6() {
    local src_ip=$1
    local target_ipv6=$2
    local temp_file=$3
    local ping_output=$(/usr/bin/ping6 -I $src_ip -i 0.3 -c 30 $target_ipv6 2>&1)
    /usr/bin/ip addr del $src_ip/64 dev eth0
    local loss=$(echo "$ping_output" | grep 'packets transmitted' | awk '{print $6}')
    if [ "$loss" == "100%" ]; then
        return
    fi
    local min=$(echo "$ping_output" | grep 'rtt min/avg/max/mdev' | cut -d'=' -f2 | awk -F'/' '{print $1}')
    echo "$src_ip $min" >> "$temp_file"
}

current_ipv6=$(ip -6 addr show eth0 | grep 'inet6' | grep -v 'fe80' | awk '{print $2}' | cut -d'/' -f1 | head -n 1)
current_prefix=$(echo $current_ipv6 | cut -d':' -f1-4)
echo ""
echo "网卡当前配置的IPv6： $current_ipv6"
echo "分配该虚拟机的IPv6： $current_prefix::/64"
echo ""
stty erase '^H' && read -p "请输入你要检测的对端IPv6: " target_ipv6
if ! [[ "$target_ipv6" =~ ^([0-9a-fA-F:]+)$ && "${#target_ipv6}" -ge 15 && "${#target_ipv6}" -le 39 ]]; then
    echo "你输入的这个地址看着不太对哇！"
    exit 1
fi
stty erase '^H' && read -p "请输入你要测试多少个IPv6: " ipv6_num
if ! [[ "$ipv6_num" =~ ^[0-9]+$ ]]; then
    echo "写的啥玩意？认真点！"
    exit 1
fi
if [ "$ipv6_num" == 0 ]; then
    echo "你看看你输的数量对吗？"
    exit 1
fi
if [ "$ipv6_num" -gt 200 ]; then
    echo "$ipv6_num个？你的小鸡要冒烟咯！"
    exit 1
fi
declare -a ip_array
echo ""
echo "在 $current_prefix::/64 中生成$ipv6_num个IPv6进行检测 请等待任务完成"

for i in $(seq 1 $ipv6_num); do
    random_part=$(printf '%x:%x:%x:%x' $((RANDOM%65536)) $((RANDOM%65536)) $((RANDOM%65536)) $((RANDOM%65536)))
    generated_ip="$current_prefix:$random_part"
    /usr/bin/ip addr add $generated_ip/64 dev eth0
    ip_array+=($generated_ip)
done

sleep 5s 
temp_file=$(mktemp)
declare -A ipv6_rtt_results

for src_ip in "${ip_array[@]}"; do
    ping_ipv6 "$src_ip" "$target_ipv6" "$temp_file" &
done

wait

echo ""
echo "====================================================="
echo "IPv6                                     Minimum"
sort -k2 -n "$temp_file" | head -n 10 | while read -r line; do
    ipv6=$(echo "$line" | awk '{print $1}')
    rtt=$(echo "$line" | awk '{print $2}')
    printf "%-40s %s ms\n" "$ipv6" "$rtt"
done
rm "$temp_file"
echo "====================================================="
echo "Power by PoloCloud@Wang_Boluo" #给个面子别删吧哥
