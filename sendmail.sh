#!/bin/sh
# centos动态IP服务器监控动态IP发件脚本
# Author: ltiaw<https://www.ltiaw.cf>

echo "#############################################################"
echo "#         centos动态IP服务器监控动态IP发件脚本                  #"
echo "# 网址: https://www.ltiaw.cf                                 #"
echo "# 作者: ltiaw                                                #"
echo "#############################################################"
echo ""

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
fi
