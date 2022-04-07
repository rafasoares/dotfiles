function edit() { "${EDITOR} $@"; }
function edit_settings() { edit "$@"; source "$@"; }

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
  # local branches=($(git branch -v | awk '/gone\]/ {print $1}'))
  local branches=($(git branch -v | awk '/fix/ {print $1}'))

  echo "The following branches will be permanently deleted:"
  echo "\t${(j:\n\t:)branches}"

  local confirm=$(read -q "confirm?Do you really want to delete them? (y/n) ")
  echo

  if ! $confirm; then
    return 1
  fi

  echo "DELETED!"
}
