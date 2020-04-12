#!/bin/sh

oldip=$(curl -s https://api.ip.sb/ip)
echo "My IP address is: $oldip"
oldip=192.168.1.1
while [ "1" = "1" ]
do
	newip=$(curl -s https://api.ip.sb/ip)
	if [ $oldip = $newip ]; then
		echo "地址一样，不用换"
		continue
	else
		oldip=$newip
		echo "地址不一样"
		echo "服务器突然换IP了，请切换新的IP：$newip" |mail -s "台湾IP更换通知-by X雄" 394310052@qq.com
	fi
done
