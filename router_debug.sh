#!/bin/sh

	if [ $# -gt 0 ];then
		relay_time=$1
	else
		relay_time=300
	fi
	echo $relay_time

	file_mac=`ifconfig br0 | grep HWaddr |  cut -d' ' -f12 | sed 's/://g'`
	file_date=`date "+%Y%m%d%H%M%S"`
	file_path="$file_mac"-"$file_date"
	file_name="/tmp/""$file_path"
	echo "$file_name"
	while [ 1 ]
	do
		echo "start @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@" >> $file_name
		free > $file_name
		echo "***************************************" >> $file_name
		cat /proc/meminfo >> $file_name
		echo "***************************************" >> $file_name
		cat /proc/slabinfo >> $file_name
		echo "***************************************" >> $file_name
		cat /proc/net/tcp >> $file_name
		echo "***************************************" >> $file_name
		cat /proc/net/udp >> $file_name
		echo "***************************************" >> $file_name
		cat /proc/net/unix  >> $file_name
		echo "***************************************" >> $file_name
		cat /proc/net/nf_conntrack >> $file_name
		echo "***************************************" >> $file_name
		cat /proc/interrupts >> $file_name
		echo "***************************************" >> $file_name
		netstat -an >> $file_name
		echo "***************************************" >> $file_name
		cat /proc/net/sockstat >> $file_name
		echo "***************************************" >> $file_name
		ps >> $file_name
		echo "***************************************" >> $file_name
		for file in `ls /proc/`
		do
			if [ "$file" -gt 0 ] 2>/dev/null ;then  
				file_wchan="/proc/""$file""/wchan"
				echo -n $file  >> $file_name
				echo -n "    "   >> $file_name
				cat $file_wchan >> $file_name
				echo "    "   >> $file_name
			fi 
		done
		echo "end &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&" >> $file_name
		
		i=0
        	num=3   
        	while [ $i -lt $num ]
        	do
			wget --method POST --header 'cache-control: no-cache'  --body-file=$file_name  http://plugintool.ifenglian.com/dev_log_201903.php?filename=$file_path -O /tmp/.router_wget.test
			echo "$file_name"
			if [ $? -eq 0 ];then
				echo "wget upload file success"
				break
			else
				echo "wget upload file err"
			fi
			let i=i+1 
		done
		#sleep 300
		sleep $relay_time
	done
	exit 0

