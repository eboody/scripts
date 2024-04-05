#!/bin/bash

# Clone TPM if not already installed
TPM_DIR="$HOME/.config/tmux/plugins/tpm"
if [ ! -d "$TPM_DIR/lib" ]; then
    git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
else
    echo "TPM is already installed."
    cd ~/.config/tmux/plugins/tpm && git pull
    echo "Pulled TPM changes"
fi
