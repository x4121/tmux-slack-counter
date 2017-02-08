# Tmux slack counter

Plugin that counts mentions and messages in [slack](https://slack.com/).

### Usage

Generate a [token](https://api.slack.com/docs/oauth-test-tokens) for the slack
API and store it in `$TMUX_PLUGIN_MANAGER_PATH/tmux-slack-counter/token`.

Add `#{slack_dms}`, `#{slack_mentions}` and `#{slack_messages}` to your `status-right`
```tmux.conf
set -g status-right 'Slack: #{slack_dms}/#{slack_mentions}/#{slack_messages} | %a %Y-%m-%d %H:%M'
```

### Installation with Tmux Plugin Manager (recommended)

Add plugin to the list of TPM plugins:

```tmux.conf
set -g @plugin 'x4121/tmux-slack-counter'
```

Press prefix + I to install it.

### Manual Installation

Clone the repo:

```bash
$ git clone https://github.com/x4121/tmux-slack-counter.git ~/clone/path
```

Add this line to your .tmux.conf:

```tmux.conf
run-shell ~/clone/path/tmux-slack-counter.tmux
```

Reload TMUX environment with:

```bash
$ tmux source-file ~/.tmux.conf
```

### License

[MIT](LICENSE)
