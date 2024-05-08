function edit() { "${EDITOR} $@"; }
function edit_settings() {
  if [[ $(command -v chezmoi) && $(chezmoi cat "$@" 2>&1 /dev/null) ]]; then
    chezmoi edit "$@"
    chezmoi apply 2>&1 /dev/null
  else
    edit "$@"
  fi

  exec zsh --login
}

#mkdir and cd
function mkcd() { mkdir -p "$1" && cd "$_" || exit; }

# FileSearch
function f() { find . -iname "*$1*" "${@:2}"; }
function r() { grep "$1" "${@:2}" -R .; }

# Copies .sample/.example files, removing the .sample/.example extension
function unsample() {
  for file in **/?(.)*.@(sample|example); do
    cp "$file" "${file/.(sample|example)/}"
  done
}

function gclb() {
  local branches=($(git branch --format "%(refname:short) %(upstream:track)" | awk '/\[gone\]/ {print $1}'))

  echo "The following branches will be permanently deleted:"
  echo "\t${(j:\n\t:)branches}"

  read -q "confirm?Do you really want to delete them? (y/n) "
  echo

  if [[ "${confirm}" = 'y' ]]; then
    for branch in $branches; do
      git branch -vD ${branch}
    done
  else
    return 1
  fi
}

function install-all-deps() {
  if [[ -f Gemfile ]]; then
    bundle install
  fi

  if [[ -f package.json ]]; then
    if [[ -f yarn.lock ]]; then
      yarn install
    elif [[ -f pnpm-lock.yaml ]]; then
      pnpm install
    else
      npm install
    fi
  fi
}

# Add a spacer to the dock
function add-dock-spacer() {
  local size=""
  if [[ $1 == "" || "$1" == "-s" || "$1" == "--small" ]]; then
    size="small-"
  elif [[ "$1" == "--large" || "$1" == "-l" ]]; then
    size=""
  elif [[ "$1" != "" ]]; then
    echo << EOF
Usage: add-dock-spacer [-s|--small|-l|--large]
  -s|--small: Add a small spacer (default)
  -l|--large: Add a large spacer
EOF

    return 1
  fi

  local tile="${size}spacer-tile"

  defaults write com.apple.dock persistent-apps -array-add '{"tile-type" = "'${tile}'";}'
  killall Dock
}

if ! type "spacer" > /dev/null; then alias spacer="add-dock-spacer"; fi

# re-merge all remote branches with a specific label (staging by default) into current branch
function remerge() {
  local label="${1:-staging}"
  local query='.[] | select(.mergeable == "MERGEABLE") | .headRefName'
  local branches=($(gh pr list --label "${label}" --json headRefName,mergeable --jq "${query}" | sort -u | xargs))

  for branch in $branches; do
    echo "Merging ${branch}"
    git merge --no-edit "origin/${branch}"
  done
}

function conflicting() {
  local cmd=[ "$(command -v catp)" ] && catp || cat

  gh pr list --label "staging" --json title,number,mergeable,url,author --jq '.[] | select(.mergeable != "MERGEABLE") | "[\(.title) (#\(.number))](\(.url)) - @\(.author.login)"' | cmd
}
