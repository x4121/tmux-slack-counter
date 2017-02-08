#!/usr/bin/env bash

counter="$1"
age="$2"

mentions=". -map(select(.is_archived)) | .[].mention_count_display]"
messages=". -map(select(.is_archived or .is_muted)) | .[].unread_count_display]"
join=".groups + .channels"
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
tmp="$dir/../tmp"

download() {
    local -r slack_token="$(cat $dir/../token)"


    if ! test "$(find $tmp -newermt "$age ago")"; then
        curl -s -d "token=$slack_token" -o "$tmp" https://slack.com/api/users.counts
    fi
}

main() {
    download
    case "$counter" in
        slack_dms)
            jq '[.ims[].dm_count] | add' "$tmp"
            ;;
        slack_mentions)
            jq "[$join | $mentions | add" "$tmp"
            ;;
        slack_messages)
            jq "[$join | $messages | add" "$tmp"
            ;;
    esac
}

main
