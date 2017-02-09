#!/usr/bin/env bash

counter="$1"
age="$2"
if [[ -z ${age// } ]]; then
    age='10 seconds'
fi

api='https://slack.com/api/users.counts'
mentions='. -map(select(.is_archived)) | .[].mention_count_display]'
messages='. -map(select(.is_archived or .is_muted)) | .[].unread_count_display]'
join='.groups + .channels'

dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
tmp_out="$dir/../tmp"
err_out="$dir/../err"
token="$dir/../token"

append=''

err() {
    echo "$1"
    exit 1
}

main() {
    if [[ -f $err_out ]]; then
        err 'ERR'
    fi

    if ! jq --version >/dev/null 2>&1; then
        err 'NO_JQ'
    fi

    if [[ ! -s $token ]]; then
        err 'TOK'
    fi

    slack_token="$(cat "$token")"
    if ! test "$(find "$tmp_out" -newermt "$age ago")"; then
        if js="$(curl -s -d "token=$slack_token" $api)"; then
            case "$(echo "$js" | jq -r '.error')" in
                null)
                    echo "$js" > "$tmp_out"
                    ;;
                not_authed)
                    ;&
                invalid_auth)
                    ;&
                account_inactive)
                    err 'AUTH'
                    ;;
                *)
                    echo "$js" > "$err_out"
                    err 'ERR'
                    ;;
            esac
        else
            if [[ ! -s $tmp_out ]]; then
                err '?'
            else
                append='?'
            fi
        fi
    fi

    case "$counter" in
        slack_dms)
            echo "$(jq '[.ims[].dm_count] | add' "$tmp_out")$append"
            ;;
        slack_mentions)
            echo "$(jq "[$join | $mentions | add" "$tmp_out")$append"
            ;;
        slack_messages)
            echo "$(jq "[$join | $messages | add" "$tmp_out")$append"
            ;;
    esac
}

main
