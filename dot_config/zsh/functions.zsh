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
# function r() { grep "$1" "${@:2}" -R .; }

# Copies .sample/.example files, removing the .sample/.example extension
function unsample() {
  for file in **/?(.)*.@(sample|example); do
    cp "$file" "${file/.(sample|example)/}"
  done
}

# Cleans up git branches that are gone from the remote
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

# Fetches all my PRs from last week and prints out a summary
function weekly-updates() {
  local last_week=$(date -v-7d -v-monday "+%Y-%m-%d")
  local query="created:>=${last_week}"
  local fields="title,createdAt,url,state"
  local template='{{range .}}- {{ .title }} ( [#{{ .number }}]({{ .url }}) ){{ if ne .state "MERGED" }} (WIP) {{ end }} {{ "\n" }}{{ end }}'

  gh pr list --author @me -s open -s merged --search "${query}" --json $fields -t "${template}"
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
    git merge --no-edit --no-ff "origin/${branch}"
  done
}

remove_conflicting_git_completions() {
    local git_completion_bash="$(brew --prefix)/share/zsh/site-functions/git-completion.bash"
    local git_completion_zsh="$(brew --prefix)/share/zsh/site-functions/_git"

    [ -e "$git_completion_bash" ] && rm "$git_completion_bash"
    [ -e "$git_completion_zsh" ] && rm "$git_completion_zsh"
}

# Rails database console in Kubernetes pod
function k8s_rails_dbconsole() {
  local -a replica namespace prefix length help
  zparseopts -D -E -- \
    r=replica -replica=replica \
    n:=namespace -namespace:=namespace \
    p:=prefix -prefix:=prefix \
    l:=length -length:=length \
    h=help -help=help

  if (( ${#help} )); then
    cat <<EOF
Usage: k8s_rails_dbconsole <resource> [db_name] [options]

Opens a Rails database console in a Kubernetes pod.

Arguments:
  resource        Pod or resource to exec into (POD | TYPE/NAME)
                  Examples: my-pod, deploy/my-app, svc/my-service
  db_name         Database name or shard number (optional)

Options:
  -n, --namespace <ns>      Kubernetes namespace
  -p, --prefix <prefix>     Database name prefix for numeric shards
  -l, --length <len>        Zero-padding length for numeric shards
  -r, --replica             Connect to replica database
  -h, --help                Show this help message

Examples:
  k8s_rails_dbconsole deploy/my-app -n production -p shard -l 2 1
    -> kubectl exec -it deploy/my-app -n production -- bin/rails db -p --db=shard01

  k8s_rails_dbconsole deploy/my-app -p db -l 3 5 -r
    -> kubectl exec -it deploy/my-app -- bin/rails db -p --db=db005_replica

  k8s_rails_dbconsole deploy/my-app analytics
    -> kubectl exec -it deploy/my-app -- bin/rails db -p --db=analytics
EOF
    return 0
  fi

  local resource="$1"
  local db_name="${2:-}"

  # Normalize db_name
  if [[ -n "$db_name" ]]; then
    if [[ "$db_name" =~ ^[0-9]+$ && ${#prefix} -gt 0 && ${#length} -gt 0 ]]; then
      db_name="${prefix[-1]}$(printf "%0${length[-1]}d" "$db_name")"
    fi

    if (( ${#replica} )); then
      db_name="${db_name}_replica"
    fi
  fi

  # Build kubectl args
  local -a kubectl_args=(exec -it "${resource}")
  if (( ${#namespace} )); then
    kubectl_args+=(-n "${namespace[-1]}")
  fi

  # Build rails command
  local cmd="bin/rails db -p"
  if [[ -n "$db_name" ]]; then
    cmd="${cmd} --db=${db_name}"
  fi

  kubectl "${kubectl_args[@]}" -- ${=cmd}
}
