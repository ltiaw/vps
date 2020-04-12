#!/bin/sh

API_URL="https://my.moonvm.com/ddns.php?product=1934&flag=changeip&iptoken=QE4SFTyttd"

ipchange() {
        oldip=`curl ip.sb|awk -F. '$1<=255&&$2<=255&&$3<=255&&$4<=255&&length($0)<16 {print $0}'`
        echo 'oldip:'$oldip
        changipResult=0
        while [ $changipResult -eq "0" ]; do
                curl --connect-timeout 20 -m 20 $API_URL > /tmp/ip.txt
                isSuccess=`grep 'newip' /tmp/ip.txt | wc -l`
                if [ $isSuccess -eq "1" ] ; then
                        changipResult=1
                        getip=`awk -F',' '{print $3;}' /tmp/ip.txt | awk -F'"' '{print $4;}'`
                else
                        newip=`curl ip.sb|awk -F. '$1<=255&&$2<=255&&$3<=255&&$4<=255&&length($0)<16 {print $0}'`
                        if [ "$oldip" = "$newip" ];then
                                echo "fail,retry"
                        else
                                echo 'newip:'$newip
                                getip=$newip
                                break
                        fi
                        sleep 10
                fi
        done
}

result=0
getip=`curl -s ip.sb|awk -F. '$1<=255&&$2<=255&&$3<=255&&$4<=255&&length($0)<16 {print $0}'`
while [ $result -eq "0" ]; do
        china_telecom=`curl -s -I -4 --connect-timeout 6 -m 6 --retry 0 http://www.189.cn | grep "Content-Type" | wc -l`
        chinamobile=`curl -s -I -4 --connect-timeout 6 -m 6 --retry 0 http://www.10086.cn | grep "Content-Type" | wc -l`
        if [ $chinamobile -eq "1" ] || [ $china_telecom -eq "1" ] ; then
                echo "goodip">>/var/log/sendmailog
                result=1
        else
                echo $getip" badip,retry ipchange"
                echo "`date`当前服务器IP：$new_ip 被墙了，立即执行换IP程序" |mail -s "台湾IP状态通知" 394310052@qq.com
                ipchange
                sleep 5
        fi
done


old_ip=`cat /root/ip.txt`
#echo "My IP address is: $old_ip"
#old_ip=192.168.1.1
new_ip=$(curl -s https://api.ip.sb/ip)
if [ $old_ip = $new_ip ]; then
        echo "`date`地址一样。不用换">>/var/log/sendmailog
        #echo "`date` 当前服务器IP：$new_ip 正常，请继续使用" |mail -s "台湾IP状态通知" 394310052@qq.com
else
        echo $new_ip >/root/ip.txt
        echo "`date`地址不一样">>/var/log/sendmailog
        echo "`date`服务器突然换IP了，请切换为新的IP:$new_ip" |mail -s "台湾IP更换通知" 394310052@qq.com
        echo "`date`服务器突然换IP了，请切换为新的IP:$new_ip" |mail -s "台湾IP更换通知" 2428186497@qq.com
        echo "`date`服务器突然换IP了，请切换为新的IP:$new_ip" |mail -s "台湾IP更换通知" 2397338624@qq.com
fi