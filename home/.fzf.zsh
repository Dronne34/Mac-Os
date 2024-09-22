# Setup fzf
# ---------
if [[ ! "$PATH" == */Users/ciprian/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/Users/ciprian/.fzf/bin"
fi

source <(fzf --zsh)
