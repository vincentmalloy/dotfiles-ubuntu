# git shorthand
# No arguments: `git status`
# With arguments: acts like `git`
g() {
  if [[ $# -gt 0 ]]; then
    git "$@"
  else
    git status -sb
  fi
}
gg() {
  if [[ $# -gt 0 ]]; then
    git add .;git commit -m "$@";git push
  else
    git add .;git commit -m "update";git push
  fi
}
# From Dan Ryan's blog - http://danryan.co/using-antigen-for-zsh.html
man () {
  # Shows pretty `man` page.
  env \
    LESS_TERMCAP_mb=$(printf "\e[1;31m") \
    LESS_TERMCAP_md=$(printf "\e[1;31m") \
    LESS_TERMCAP_me=$(printf "\e[0m") \
    LESS_TERMCAP_se=$(printf "\e[0m") \
    LESS_TERMCAP_so=$(printf "\e[1;32;33m") \
    LESS_TERMCAP_ue=$(printf "\e[0m") \
    LESS_TERMCAP_us=$(printf "\e[1;32m") \
      man "$@"
}

# flush typo3 cache in ddev project
flush () {
  # get installed version of typo3/cms-core
  composer_version=`ddev composer show 'typo3/cms-core' | sed -n '/versions/s/^[^0-9]\+\([^,]\+\).*$/\1/p' | cut -d '.' -f1`
  # if composer_version > 11, use typo3, else use typo3cms
  if [ $composer_version -gt 11 ]; then
    ddev typo3 cache:flush
  else
    ddev typo3cms cache:flush
  fi
  echo "wiped typo3 cache"
}
# setup some local ddev settings
ddevsetup () {
  # check if .ddev/config.yaml exists
  if [ -f .ddev/config.yaml ]; then
    # check if .vscode directory exists
    if [ ! -d .vscode ]; then
      mkdir .vscode
    fi
    # download vscode launch.json and tasks.json
    wget https://ddev.readthedocs.io/en/latest/users/snippets/launch.json -O .vscode/launch.json
    wget https://ddev.readthedocs.io/en/latest/users/snippets/tasks.json -O .vscode/tasks.json
    echo "xdebug setup complete"
  else
    echo "no .ddev/config.yaml found, is this a ddev project?"
  fi
}
# fuzzy ripgrep search
function frg {
  result=$(rg --ignore-case --color=always --line-number --no-heading "$@" |
    fzf --ansi \
        --color 'hl:-1:underline,hl+:-1:underline:reverse' \
        --delimiter ':' \
        --preview "batcat --color=always {1} --theme='Solarized (light)' --highlight-line {2}" \
        --preview-window 'up,60%,border-bottom,+{2}+3/3,~3')
  file=${result%%:*}
  linenumber=$(echo "${result}" | cut -d: -f2)
  if [[ -n "$file" ]]; then
          $EDITOR +"${linenumber}" "$file"
  fi
}
# get weather
function wttr {
  if [ -z $1 ];
    then
      curl wttr.in/idar-oberstein\?format\=3
    else
      curl wttr.in/$1\?format\=3
  fi
}
