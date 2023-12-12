alias zrc="edit_settings ~/.zshrc"
alias omz="edit_settings ~/.oh-my-zsh"
alias pl10k="edit_settings ~/.p10k.zsh"

alias bnfo="bundle info"
alias b="bundle"


if command -v bat &> /dev/null; then
  alias cat='bat --style header --style rules --style snip --style changes --style header'
fi

if command -v eza &> /dev/null; then
  alias ls='eza --icons --group-directories-first --git --color=always'

  alias l='ls -lFh'
	alias lS='ls -1FSsh'
	alias la='ls -lAFh'
	alias lart='ls -1Fcart'
	alias ldot='ls -ld .*'
	alias ll='ls -l'
	alias lr='ls -tRFh'
	alias lrt='ls -1Fcrt'
	alias ls='ls -G'
	alias lsa='ls -lah'
	alias lsn='ls -1'
	alias lsr='ls -lARFh'
	alias lt='ls -ltFh'
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
