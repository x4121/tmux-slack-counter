#!/usr/bin/env bash

interpolate() {
    counter="$1"

    status="status-right"
    status_value=$(tmux show-option -gqv "$status")
    dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"
    replace="\#{$counter}"
    cmd="#($dir/scripts/get_slack_counter.sh $counter)"
    tmux set-option -gq "$status" "${status_value/$replace/$cmd}"
}

main() {
    interpolate 'slack_dms'
    interpolate 'slack_mentions'
    interpolate 'slack_messages'
}

main
