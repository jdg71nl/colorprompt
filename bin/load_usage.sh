#!/bin/bash
#= load_average.sh

# jdg idea from: https://superuser.com/questions/1402079/understanding-load-average-and-cpu-in-linux

Hostnames=$(uname -n | cut -d. -f1)
os_type=$(uname -s)

case "$os_type" in

  Linux)
# Define color variables
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
NC="\033[0m" # No Color

cputhreshold=99.0

# Get the CPU load averages
load_avg_1min=$(uptime | awk -F'load average: ' '{print $2}' | cut -d ',' -f1 | tr -d ' ')
load_avg_5min=$(uptime | awk -F'load average: ' '{print $2}' | cut -d ',' -f2 | tr -d ' ')
load_avg_15min=$(uptime| awk -F'load average: ' '{print $2}' | cut -d ',' -f3 | tr -d ' ')

# Get the number of CPU cores
cpu_core=$(nproc --all)

# Calculate percentages
percentage_1min=$(echo "scale=2; ($load_avg_1min / $cpu_core) * 100" | bc)
percentage_5min=$(echo "scale=2; ($load_avg_5min / $cpu_core) * 100" | bc)
percentage_15min=$(echo "scale=2; ($load_avg_15min / $cpu_core) * 100" | bc)

if (( $(echo "$percentage_1min >= $cputhreshold" | bc -l) )); then
# Print the table header in a box
printf "+------------------+-------------------+------------------+-----------------+--------+\n"
printf "| %-16s | %-17s | %-16s | %-14s | %-06s |\n" "HostName" "Time Intervals" "Load Average" "System Load (%)" "Status"
printf "+------------------+-------------------+------------------+-----------------+--------+\n"

# Print the table rows
printf "| %-16s | %-17s | %-16s | %-15s | ${YELLOW}%-06s${NC} |\n" "" "1 minute" "$load_avg_1min" "$percentage_1min%" ""
printf "| %-16s | %-17s | %-16s | %-15s | ${YELLOW}%-06s${NC} |\n" "$Hostnames" "5 minutes" "$load_avg_5min" "$percentage_5min%" "High"
printf "| %-16s | %-17s | %-16s | %-15s | ${YELLOW}%-06s${NC} |\n" "" "15 minutes" "$load_avg_15min" "$percentage_15min%" ""

# Print the bottom border of the table box
printf "+------------------+-------------------+------------------+-----------------+--------+\n"
else
# Print the table header in a box
printf "+------------------+-------------------+------------------+-----------------+--------+\n"
printf "| %-16s | %-17s | %-16s | %-14s | %-06s |\n" "HostName" "Time Intervals" "Load Average" "System Load (%)" "Status"
printf "+------------------+-------------------+------------------+-----------------+--------+\n"

# Print the table rows
printf "| %-16s | %-17s | %-16s | %-15s | ${GREEN}%-06s${NC} |\n" "" "1 minute" "$load_avg_1min" "$percentage_1min%" ""
printf "| %-16s | %-17s | %-16s | %-15s | ${GREEN}%-06s${NC} |\n" "$Hostnames" "5 minutes" "$load_avg_5min" "$percentage_5min%" "Normal"
printf "| %-16s | %-17s | %-16s | %-15s | ${GREEN}%-06s${NC} |\n" "" "15 minutes" "$load_avg_15min" "$percentage_15min%" ""

# Print the bottom border of the table box
printf "+------------------+-------------------+------------------+-----------------+--------+\n"
fi
    ;;

  *)
    echo -e "This script is not supported for $os_type - $Hostnames"
    ;;
esac

#-eof

