#!/bin/bash

Current_user=$(whoami)
Hostname=$(hostname)
Current_date=$(date)
Uptime=$(uptime -p)

Total_mem=$(free -m | awk '/^Mem:/{print $2}')
Used_mem=$(free -m | awk 'NR==2{print $3}')
Available_mem=$(free -m | awk '/^Mem:/ {print $7}')
Total_disk=$(df -BG --output=size / | tail -1 | sed 's/G//')
Used_disk=$(df -BG --output=used / | tail -1 | sed 's/G//')
Free_disk=$(df -BG --output=avail / | tail -1 |sed 's/G//')
Low=$(( Total_mem / 4 ))
Low_disk=$(( Total_disk / 4 ))

Running_processes=$(ps -e | wc -l )
Top_consuming=$(ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head -n 6) #--sort=-%mem (is for sorting in descending order)
Cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')

echo "========================================"
echo "         "
echo " WELCOME TO THE SYSTEM INFO DASHBOARD "
echo "========================================"
echo " "
echo "User: $Current_user"
echo "Host: $Hostname"
echo "Date: $Current_date"
echo ""
echo "#### Uptime ####"
echo "$Uptime"
echo ""
echo "#### Memory(MB) ####"
echo ""
echo "Total: ${Total_mem} | Used: ${Used_mem} | Free: ${Available_mem}"
echo ""

if [[ "$Available_mem" -le "$Low" ]]; then
  echo -e "\e[31mLow Disk Space\e[0m"
else
  echo -e "\e[32msufficient Disk Space\e[0m"
fi
echo "#### Disk Usage ####"
echo ""
echo "Total: ${Total_disk} | Used: ${Used_disk} | Free: ${Free_disk} "

if [[ "$Free_disk" -le "$Low_disk" ]]; then
  echo -e "\e[31mLow Disk Space\e[0m"
else
  echo -e "\e[32mSufficient Disk Space\e[0m"
fi
echo ""
echo "#### Processes ####"
echo ""
echo "Running: $Running_processes"
echo ""
echo "Top 5 by memory: $Top_consuming "
echo ""
echo "#### CPU Usage ####"
echo ""
echo "Current cpu usage: ${Cpu_usage}"
echo ""
echo "==================================================="