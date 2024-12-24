#!/bin/bash

# Define Backup Directory
BACKUP_DIR="$HOME/brew-backup"
DATE=$(date +"%Y-%m-%d_%H-%M-%S")
FORMULAE_BACKUP_FILE="$BACKUP_DIR/formulae_no_dependencies_$DATE.txt"
CASKS_BACKUP_FILE="$BACKUP_DIR/casks_$DATE.txt"

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# Step 1: Backup top-level installed formulae (without dependencies)
echo "Backing up top-level Homebrew formulae (without dependencies)..."
brew leaves > "$FORMULAE_BACKUP_FILE"

# Step 2: Backup installed Homebrew casks
echo "Backing up installed Homebrew casks..."
brew list --cask > "$CASKS_BACKUP_FILE"

echo "Backup complete. Formulae saved to: $FORMULAE_BACKUP_FILE"
echo "Casks saved to: $CASKS_BACKUP_FILE"

# Step 3: Optionally, uninstall all installed formulae and casks (uncomment to enable)
# echo "Uninstalling all formulae..."
# brew uninstall --force --ignore-dependencies $(brew list --formula)

# echo "Uninstalling all casks..."
# brew uninstall --force --ignore-dependencies $(brew list --cask)

# Step 4: Reinstall formulae and casks from backup lists
echo "Reinstalling Homebrew formulae..."
if [ -f "$FORMULAE_BACKUP_FILE" ]; then
  cat "$FORMULAE_BACKUP_FILE" | while read -r formula; do
    # Check if formula is already installed
    if ! brew list --formula | grep -q "^$formula$"; then
      brew install "$formula"
    else
      echo "Skipping already installed formula: $formula"
    fi
  done
  echo "Formulae reinstallation complete."
else
  echo "No formulae backup found, skipping reinstallation of formulae."
fi

echo "Reinstalling Homebrew casks..."
if [ -f "$CASKS_BACKUP_FILE" ]; then
  cat "$CASKS_BACKUP_FILE" | while read -r cask; do
    # Check if cask is already installed
    if ! brew list --cask | grep -q "^$cask$"; then
      brew install --cask "$cask"
    else
      echo "Skipping already installed cask: $cask"
    fi
  done
  echo "Casks reinstallation complete."
else
  echo "No casks backup found, skipping reinstallation of casks."
fi

# End of script
