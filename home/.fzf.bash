# Setup fzf
# ---------
if [[ ! "$PATH" == */Users/ciprian/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/Users/ciprian/.fzf/bin"
fi

eval "$(fzf --bash)"
