#!/bin/bash
prev_proc=$(ps -eo command)

while true; do
current_proc=$(ps -eo command)
diff <(echo "$prev_proc") <(echo "$current_proc")
sleep 1
prev_proc=$current_proc
done
