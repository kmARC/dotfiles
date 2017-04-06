WINDOW_ID=$(wmctrl -l | grep 'tmux.*Session' | grep $HOSTNAME | awk '{print $1}')
echo "Window_ID: $WINDOW_ID"
if [ ! -z "$WINDOW_ID" ]; then
    echo "exists"
    # Window exist, switch to it
    bspc node -f $WINDOW_ID
    tmux select-window -t music
else
    echo "not exists"
    urxvtcd -ls -e bash -ci 'tmux attach -t Session \; find-window music'
fi
