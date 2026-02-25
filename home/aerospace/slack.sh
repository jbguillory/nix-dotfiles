#!/bin/bash
CURRENT=$(aerospace list-workspaces --focused)
SLACK_WINDOW=$(aerospace list-windows --all | grep -i slack | awk '{print $1}')
if [ -n "$SLACK_WINDOW" ]; then
  aerospace move-node-to-workspace --window-id $SLACK_WINDOW $CURRENT
fi
open -a /Applications/Slack.app