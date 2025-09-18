alias zrc="edit_settings ~/.zshrc"
alias omz="edit_settings ~/.oh-my-zsh"
alias aliases="edit_settings ~/.config/zsh/aliases.zsh"
alias functions="edit_settings ~/.config/zsh/functions.zsh"

alias bnfo="bundle info"
alias b="bundle"
alias bln="bundle list --name-only"

alias rts="rails --tasks"
alias rdsp="rails db:seed:replant"
alias wds="bin/webpack-dev-server --watch"

alias bup="HOMEBREW_NO_ENV_HINTS=1
brew update
brew upgrade
brew cleanup"

if command -v bat &> /dev/null; then
  alias cat='bat --style full'
  alias ccat='bat --style changes'
  alias catp='bat --style plain'
fi

if command -v eza &> /dev/null; then
  alias ls='eza --icons --group-directories-first --git --color=always --classify=always'

  # From https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/common-aliases
  # adapted to use eza
  alias l='ls -lh'                         # size, show type, human readable
  alias la='ls -lah'                        # long list, show almost all, show type, human readable
  alias lr='ls -lRh -stime'                 # sorted by date, recursive, show type, human readable
  alias lt='ls -lh -stime'                 # long list, sorted by date, show type, human readable
  alias ll='ls -l'                          # long list
  alias ldot='ls -ld .*'                    # list dot files
  alias lS='ls -lhr -ssize --total-size'   # long list, sort by size, human readable
  alias lart='ls -1a -stime'               # 1 col, recursive, sorted by date, show almost all
  alias lrt='ls -1 -stime'                 # 1 col, recursive, sorted by date
  alias lsr='ls -Rh'                     # Recursive list of files and directories
  alias lsn='ls -1'                         # A column contains name of files and directories
fi

# gcs is `git commit -S` by default, but I already sign all my commits
# this is more useful :)
alias gcs="git checkout staging"

alias kc="kubectl config use-context"
# Specific to my work environment at @chartmogul
alias krc="kubectl exec -it deploy/platform -n platform -- entry-ssm bin/rails c"

alias hf="hyperfine"

alias c="code ."

alias chez="chezmoi"
alias chedit="chezmoi edit --apply"
alias chcfg="chezmoi edit-config"
alias chupdt="chezmoi update --apply"
alias chrc="chezmoi edit --apply ~/.zshrc"
alias chals="chezmoi edit --apply ~/.config/zsh/aliases.zsh"
alias chfn="chezmoi edit --apply ~/.config/zsh/functions.zsh"
