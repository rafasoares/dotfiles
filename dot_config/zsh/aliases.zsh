alias zrc="edit_settings ~/.zshrc"
alias omz="edit_settings ~/.oh-my-zsh"
alias pl10k="edit_settings ~/.p10k.zsh"

alias bnfo="bundle info"
alias b="bundle"

alias rts="rails --tasks"

if command -v bat &> /dev/null; then
  alias cat='bat --style full'
fi

if command -v eza &> /dev/null; then
  alias ls='eza --icons --group-directories-first --git --color=always'

  # From https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/common-aliases
  # adapted to use eza
  alias l='ls -lFh'                         # size, show type, human readable
  alias la='ls -laFh'                       # long list, show almost all, show type, human readable
  alias lr='ls -RFh -stime'                 # sorted by date, recursive, show type, human readable
  alias lt='ls -lFh -stime'                 # long list, sorted by date, show type, human readable
  alias ll='ls -l'                          # long list
  alias ldot='ls -ld .*'                    # list dot files
  alias lS='ls -lFhr -ssize --total-size'   # long list, sort by size, human readable
  alias lart='ls -1Fa -stime'               # 1 col, recursive, sorted by date, show almost all
  alias lrt='ls -1F -stime'                 # 1 col, recursive, sorted by date
  alias lsr='ls -laRFh'                     # Recursive list of files and directories
  alias lsn='ls -1'                         # A column contains name of files and directories
fi

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
