#/usr/bin/env bash
for i in $(ps aux | grep -i chrome | awk '{print $2}'); do kill $i; done
