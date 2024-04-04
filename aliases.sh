export SSH_AUTH_SOCK=~/.1password/agent.sock

eval "$(starship init bash)"

alias ls="eza"
alias la="eza -la"
alias cat="bat"

alias cw="cargo watch -c -q -w src/ -x \"run\""
alias ct="cargo watch -c -q -w tests/ -x \"test -q quick_dev -- --nocapture\""
alias clippy="cargo clippy -- -W clippy::pedantic -W clippy::nursery -W clippy::unwrap_used"

alias brc="nvim ~/.bashrc"
alias sb="source ~/.bashrc"

# alias kb="~/scripts/keyboard_setup.sh"
# alias thunderstorm="mpv --loop ~/Music/thunderstorm.flac"

eval "$(zoxide init --cmd cd bash)"
