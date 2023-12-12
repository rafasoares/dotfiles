alias zrc="edit_settings ~/.zshrc"
alias omz="edit_settings ~/.oh-my-zsh"
alias pl10k="edit_settings ~/.p10k.zsh"

alias bnfo="bundle info"
alias b="bundle"

alias cat='bat --style header --style rules --style snip --style changes --style header'
alias eza='eza --icons --group-directories-first --git --color=always'
alias l='eza -lh'
alias ll='eza -lh'
alias la='eza -lah'
alias lt='eza -lTh'
alias lta='eza -lTah'

# gcs is `git commit -S` by default, but I already sign all my commits
# this is more useful :)
alias gcs="git checkout staging"

alias kc="kubectl config use-context"

alias hf="hyperfine"

alias c="code ."

alias chez="chezmoi"
alias chedit="chezmoi edit --apply"
alias chcfg="chezmoi edit-config --apply"
alias chupdt="chezmoi update --apply"
