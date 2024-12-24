#!/usr/bin/env bash

HISTTIMEFORMAT="%d/%m/%y %T "

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi

# Fontawesome scripts
if [ -f "$HOME"/.fontscripts ];
then
    source "$HOME/.fontscripts"
fi

# set PATH so it includes user's private application if it exists
if [ -d "$HOME/.local/share/applications" ] ; then
    PATH="$HOME/.local/share/applications:$PATH"
fi


# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/shell" ] ; then
    PATH="$HOME/.local/shell:$PATH"
fi


# MPD daemon start (if no other user instance exists)
[ ! -s ~/.config/mpd/pid ] && mpd

if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
  exec startx
fi
