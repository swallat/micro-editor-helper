#!/bin/bash

# Funktion zur Installation von micro
install_micro() {
  if ! command -v micro &> /dev/null; then
    if command -v apt-get &> /dev/null; then
      echo "Installing micro using apt-get..."
      sudo apt-get update
      sudo apt-get install -y micro
    elif command -v yum &> /dev/null; then
      echo "Installing micro using yum..."
      sudo yum install -y micro
    elif command -v dnf &> /dev/null; then
      echo "Installing micro using dnf..."
      sudo dnf install -y micro
    elif command -v pacman &> /dev/null; then
      echo "Installing micro using pacman..."
      sudo pacman -Syu --noconfirm micro
    elif command -v brew &> /dev/null; then
      echo "Installing micro using brew..."
      brew install micro
    elif command -v snap &> /dev/null; then
      echo "Installing micro using snap..."
      sudo snap install micro --classic
    elif command -v zypper &> /dev/null; then
      echo "Installing micro using zypper..."
      sudo zypper install -y micro
    else
      echo "No supported package manager found. Installing micro using curl..."
      curl https://getmic.ro | bash
    fi
  else
    echo "micro is already installed."
  fi
}

# Sicherstellen, dass das bin-Verzeichnis existiert
mkdir -p "$HOME/bin"

# Prüfen, ob das Skript mit dem Parameter --uninstall aufgerufen wurde
if [[ "$1" == "--uninstall" ]]; then
  echo "Removing editor-select script and aliases..."
  rm -f "$HOME/bin/editor-select"

  # Entfernen der Aliase aus Bash und Zsh Profilen
  sed -i '/alias vim=~\/bin\/editor-select/d' "$HOME/.bashrc"
  sed -i '/alias nano=~\/bin\/editor-select/d' "$HOME/.bashrc"
  sed -i '/alias vim=~\/bin\/editor-select/d' "$HOME/.zshrc"
  sed -i '/alias nano=~\/bin\/editor-select/d' "$HOME/.zshrc"

  echo "Uninstallation completed. Aliases and editor-select script removed."
  exit 0
fi

# micro installieren
install_micro

# Create editor-select script
cat << 'EOF' > "$HOME/bin/editor-select"
#!/bin/bash

# Benutzerauswahl abfragen
echo "Do you want to use vim, micro, or nano? (v/m/n) [Default: m]"
read -r editor_choice

# Standardauswahl auf 'm' setzen, wenn keine Eingabe gemacht wurde
editor_choice=${editor_choice:-m}

# Editor basierend auf Benutzerauswahl starten
case "$editor_choice" in
    v|V)
        vim "$@"
        ;;
    m|M)
        micro "$@"
        ;;
    n|N)
        nano "$@"
        ;;
    *)
        echo "Invalid choice. Please choose 'v' for vim, 'm' for micro, or 'n' for nano."
        exit 1
        ;;
esac
EOF

# Make editor-select executable
chmod +x "$HOME/bin/editor-select"

# Add aliases to Bash profile
if ! grep -q "alias vim='~/bin/editor-select'" "$HOME/.bashrc"; then
    echo "alias vim='~/bin/editor-select'" >> "$HOME/.bashrc"
fi

if ! grep -q "alias nano='~/bin/editor-select'" "$HOME/.bashrc"; then
    echo "alias nano='~/bin/editor-select'" >> "$HOME/.bashrc"
fi

# Add aliases to Zsh profile
if ! grep -q "alias vim='~/bin/editor-select'" "$HOME/.zshrc"; then
    echo "alias vim='~/bin/editor-select'" >> "$HOME/.zshrc"
fi

if ! grep -q "alias nano='~/bin/editor-select'" "$HOME/.zshrc"; then
    echo "alias nano='~/bin/editor-select'" >> "$HOME/.zshrc"
fi

# Source the profiles to apply changes
source "$HOME/.bashrc" 2>/dev/null
source "$HOME/.zshrc" 2>/dev/null

echo "Installation completed. You can now use 'vim', 'micro', or 'nano' with the editor-select script."