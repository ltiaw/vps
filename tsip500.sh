#!/bin/bash
old_ip=`cat /root/dip500.txt`
new_ip=`nslookup 513f200d-ff93-4ffc-ac3c-307a2efe8785.ddns.moonvm.net|tail -2|head -1|cut -d" " -f2`
if [ $old_ip = $new_ip ]; then
        echo "`date` 地址一样。不用换">>/var/log/sendmailog
        #echo "`date` 地址一样。不用换"
        echo "`date` 当前服务器IP：$new_ip 正常，请继续使用" |mail -s "【台湾500】IP状态通知" 394310052@qq.com
else
        echo $new_ip >/root/dip500.txt
        echo "`date` 地址不一样$new_ip">>/var/log/sendmailog
        firewall-cmd --permanent --remove-forward-port=port=21568:proto=tcp:toport=21568:toaddr=$old_ip
        firewall-cmd --permanent --remove-forward-port=port=21568:proto=udp:toport=21568:toaddr=$old_ip
        firewall-cmd --permanent --add-forward-port=port=21568:proto=tcp:toport=21568:toaddr=$new_ip
        firewall-cmd --permanent --add-forward-port=port=21568:proto=udp:toport=21568:toaddr=$new_ip
        firewall-cmd --reload
        echo "`date` 删除旧端口，新端口添加成功"
        echo "`date` 服务器突然换IP了，中转更换成功:$new_ip" |mail -s "【台湾500】中转IP更换通知" 394310052@qq.com
fi
