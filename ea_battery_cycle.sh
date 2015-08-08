#!/bin/bash

# grab battery cycle count

batteryCycle=$(system_profiler SPPowerDataType | awk '/Cycle Count/ { print $3 }')

echo "<result>${batteryCycle} cycles</result>"