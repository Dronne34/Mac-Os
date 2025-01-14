#!/bin/zsh

# Check if fzf is installed
if ! command -v fzf &> /dev/null
then
    echo "fzf is not installed. Please install fzf first."
    exit 1
fi

# Retrieve history from .zsh_history and exclude timestamped entries directly in the pipeline
history_list=$(grep -v '^:[0-9]\+:[0-9]\+;' ~/.zsh_history)

if [[ -z "$history_list" ]]; then
    echo "No commands found in history."
    exit 1
fi

# List all commands in history, pipe through fzf, and run the selected command
selected_command=$(echo "$history_list" | fzf --height 100% --preview "echo {}")

# If a command is selected, run it
if [[ -n "$selected_command" ]]; then
    echo "Running: $selected_command"
    eval "$selected_command"
else
    echo "No command selected."
fi
