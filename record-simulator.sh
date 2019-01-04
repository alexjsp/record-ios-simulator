#!/bin/bash

# Starts and stops recording in the simulator

# Set your prefered output directory here
outputDirectory=~/Desktop/

# Open recordings in the default app when ending recording
openRecordings=true

# Choose whether to play sounds when starting and stopping a recording
playSounds=true

# Edit the format of the filename. By default it saves files with names like `Simulator 2019-01-04 at 10.16.21.mp4`
# do not add an extension to the below variable, `.mp4` will be added further down.
filename="Simulator "$(date '+%Y-%m-%d at %H.%M.%S')

tmpPathPrefix="/tmp/com.alexjsp.simulator-recording."
recordingPathVarStoragePath="$tmpPathPrefix""recordingPath.txt"
recordingPIDVarStoragePath="$tmpPathPrefix""recordingPID.txt"

function notify {
    # If running in an interactive terminal then echo status notifications,
    # otherwise post a system notification.
    if [ -t 0 ]; then
        echo $1
    else
        osascript -e 'display notification "'"$1"'" with title "Simulator Recording"'
    fi
}

if [ -f $recordingPathVarStoragePath ] && [ -f $recordingPIDVarStoragePath ]; then
    # Stop existing recording
    read recordingPath < $recordingPathVarStoragePath
    read recordingPID < $recordingPIDVarStoragePath
    rm "$tmpPathPrefix""recordingPath.txt"
    rm "$tmpPathPrefix""recordingPID.txt"
    notify "Stopping recording..."
    if [ "$playSounds" = true ] ; then
        afplay /System/Library/Sounds/Purr.aiff > /dev/null 2>&1
    fi
    sleep 2
    kill -SIGINT $recordingPID
    sleep 1
    if [ "$openRecordings" = true ] ; then
        open "$recordingPath"
    else
        notify "Recording saved to ""$recordingPath"
    fi
else
    if ! pgrep -xq -- "Simulator"; then
        notify "Simulator doesn't appear to be running"
        if [ "$playSounds" = true ] ; then
            afplay /System/Library/Sounds/Basso.aiff > /dev/null 2>&1
        fi
        exit 1
    fi
    
    # Start a new recording
    if [ "$playSounds" = true ] ; then
        afplay /System/Library/Sounds/Pop.aiff > /dev/null 2>&1
    fi
    recordingPath="$outputDirectory""$filename"".mp4"
    xcrun simctl io booted recordVideo "$recordingPath" &
    echo $! > "$tmpPathPrefix""recordingPID.txt"
    echo $recordingPath > "$tmpPathPrefix""recordingPath.txt"
    notify "Started recording to ""$recordingPath"
fi