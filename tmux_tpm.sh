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

tmux

sleep 1

# Source the tmux configuration
tmux source-file ~/.config/tmux/tmux.conf

# Start a detached tmux session, run TPM install command, and kill the session
TMUX_SESSION="tpm_setup"
tmux new-session -d -s $TMUX_SESSION
tmux send-keys -t $TMUX_SESSION "C-b" I
sleep 5 # Give some time for plugins to start installing
tmux kill-session -t $TMUX_SESSION

echo "Tmux configuration sourced and TPM plugins installation triggered."
