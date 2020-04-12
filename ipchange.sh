#!/bin/bash
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
getip=`curl ip.sb|awk -F. '$1<=255&&$2<=255&&$3<=255&&$4<=255&&length($0)<16 {print $0}'`
while [ $result -eq "0" ]; do
        chinamobile=`curl -I -4 --connect-timeout 6 -m 6 --retry 0 http://www.189.cn | grep "Content-Type" | wc -l`
        if [ $chinamobile -eq "1" ] ; then
        	echo "goodip"
			result=1
		else
			echo $getip" badip,retry ipchange"
			ipchange
			sleep 5
		fi
done

