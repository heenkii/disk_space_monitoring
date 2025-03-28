#!/bin/bash

show_help() {
  echo "Usage: $0 [filename] [interval] [disk]"
  echo "  filename - file to write data to (default: /var/log/disk_usage.log)"
  echo "  interval - interval for writing in seconds (default: 60)"
  echo "  disk     - disk to monitor (default: /)"
  exit 1
}

FILENAME="${1:-/var/log/disk_usage.log}"
INTERVAL="${2:-60}"
DISK="${3:-/}"

if ! [[ "$INTERVAL" =~ ^[0-9]+$ ]] || [ "$INTERVAL" -le 0 ]; then
  echo "Error: Interval must be a positive number" >&2
  exit 1
fi


DIR=$(dirname "$FILENAME")

if [ ! -d "$DIR" ]; then
  echo "Error: Directory $DIR does not exist" >&2
  exit 1
fi

if ! touch "$FILENAME" 2>/dev/null; then
  echo "Error: No write permissions for file $FILENAME" >&2
  exit 1
fi

if ! df "$DISK" >/dev/null 2>&1; then
  echo "Error: Disk $DISK not found" >&2
  exit 1
fi

while true; do
  CURRENT_TIME=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
  DF_OUTPUT=$(df -h "$DISK" | tail -1)
  TOTAL_SPACE=$(echo "$DF_OUTPUT" | awk '{print $2}')
  USED_SPACE=$(echo "$DF_OUTPUT" | awk '{print $3}')
  FREE_SPACE=$(echo "$DF_OUTPUT" | awk '{print $4}')
  USED_PERCENT=$(echo "$DF_OUTPUT" | awk '{print $5}')
  echo "$CURRENT_TIME - Disk: $DISK, Total: $TOTAL_SPACE, Used: $USED_SPACE, Free: $FREE_SPACE, Used: $USED_PERCENT" >> "$FILENAME"
  sleep "$INTERVAL"
done