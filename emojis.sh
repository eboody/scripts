#!/bin/bash

# Install emoji fonts and input tools
sudo paru -Syu --needed ttf-twemoji --noconfirm

# Configure fontconfig for emoji
FONTCONFIG_PATH="/etc/fonts/conf.d/01-emoji.conf"
echo "Creating fontconfig file at $FONTCONFIG_PATH..."
sudo tee "$FONTCONFIG_PATH" > /dev/null <<EOF
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>
  <alias>
    <family>sans-serif</family>
    <prefer>
      <family>Noto Color Emoji</family>
    </prefer>
  </alias>
  <alias>
    <family>serif</family>
    <prefer>
      <family>Noto Color Emoji</family>
    </prefer>
  </alias>
  <alias>
    <family>monospace</family>
    <prefer>
      <family>Noto Color Emoji</family>
    </prefer>
  </alias>
</fontconfig>
EOF

# Setup environment variables for IBus
# ENV_VARS=(
#   "export GTK_IM_MODULE=ibus"
#   "export XMODIFIERS=@im=ibus"
#   "export QT_IM_MODULE=ibus"
)

# SHELL_CONFIG="$HOME/.bashrc"  Change this to your shell configuration file as needed
#
# echo "Appending IBus environment variables to $SHELL_CONFIG..."
# for var in "${ENV_VARS[@]}"; do
#   if ! grep -q "$var" "$SHELL_CONFIG"; then
#     echo "$var" >> "$SHELL_CONFIG"
#   fi
# done
#
# echo "Installation and configuration complete!"
# echo "Please log out and back in for the changes to take effect."
# echo "After logging back in, run 'ibus-setup' to configure IBus and add UniEmoji."
#
