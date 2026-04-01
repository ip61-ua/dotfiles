#!/usr/bin/env bash

# Check if wlsunset is running
if pgrep -x "wlsunset" > /dev/null
then
    # If so, turn off the filter
    pkill -x wlsunset
else
    # else, turn on. 0 => red/orange, higher value => blue
    wlsunset -t 4000 -T 5000 &
fi
