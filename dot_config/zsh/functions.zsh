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