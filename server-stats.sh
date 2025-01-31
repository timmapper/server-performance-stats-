#!bin/bash

echo "Server Performance Stats by ami-chuu"
echo ""

idleCPU=`vmstat | tail -1 | awk '{print $15}'`
totalRAM=`vmstat -s -S M | grep "total memory" | cut -d 'M' -f 1 | tr -d " "`
usedRAM=`vmstat -s -S M | grep "used memory" | cut -d 'M' -f 1 | tr -d " "`
percentageRAM=`bc <<< "scale=2; $usedRAM/$totalRAM*100" | cut -d '.' -f 1`
totalDisk=`df -h | grep "/$" | awk '{print $2}' | tr -d [:alpha:]`
usedDisk=`df -h | grep "/$" | awk '{print $3}' | tr -d [:alpha:]`
percentageDisk=`df -h | grep "/$" | awk '{print $5}'`
top5usageCPU=`top -o =%CPU -n =1 | awk '{print $13}' | sed '1,7d' | head -5`
top5usageRAM=`top -o =%MEM -n =1 | awk '{print $13}' | sed '1,7d' | head -5`

versionOS=`lsb_release -d | cut -d ':' -f 2 | sed 's/[[=	=]]//'`
uptime=`uptime | awk '{print $3}' | sed 's/[[=,=]]//'`
loadAvg=`uptime | awk '{print $8 $9 $10}' | tr , ', '`
onlineUsers=`w | awk '{print $1}' | sed '1,2d'`

echo "Total CPU Usage: $((100 - $idleCPU))%"
echo "Total RAM Usage: $usedRAM/$totalRAM MB ($percentageRAM%)"
echo "Total Disk Usage: $usedDisk/$totalDisk GB ($percentageDisk)"
echo "Top 5 processes by CPU Usage: "
echo $top5usageCPU
echo "Top 5 processes by RAM Usage: "
echo $top5usageRAM
echo ""
echo "OS Version: $versionOS"
echo "Uptime: $uptime"
echo "Load Average: $loadAvg"
echo "Logged-in Users: "
echo $onlineUsers
exit 0
