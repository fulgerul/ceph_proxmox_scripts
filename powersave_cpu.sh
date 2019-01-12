# echo "performance" | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
echo "powersave" | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_cur_freq
sensors
grep -E '^model name|^cpu MHz' /proc/cpuinfo
