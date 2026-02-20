if [ "$3" == "" ]; then
    echo "Installing..."
    tar -xzf "$2".ppkg
    echo "Cleaning up..."
    rm "$2".ppkg
    echo "Package "$2" installed with version "$VERSION""
    #Lower frequency back to "balanced" wire_d preset
    echo 533333 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
    exit 0
else
    echo "Installing "$2" and "$3""
    tar -xzf "$2".ppkg
    tar -xzf "$3".ppkg
    echo "Cleaning up..."
    rm "$2".ppkg
    rm "$3".ppkg
    echo "Packages "$2" and "$3" installed"
    #Lower frequency back to "balanced" wire_d preset
    echo 533333 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
    exit 0
fi