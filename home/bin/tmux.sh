#!/usr/bin/env bash
tmux attach -t base || tmux new -s base vim ~/.tmux.conf \; \
split-window -h man tmux \; new-window -n File  ranger ~/ \; \
split-window -h vim ~/.zshrc \; select-pane -t 0 \; \
new-window -n Media \; split-window -h \; send-keys C-l \; select-window -t 2 \; select-pane -t 0 \; \
send-keys C-l \; select-window -t 0 \; select-pane -t 0 
