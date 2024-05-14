#!/bin/zsh

# -e: exit on error
# -u: exit on unset variables
set -eu

log_color() {
  color_code="$1"
  shift

  printf "\033[${color_code}m%s\033[0m\n" "$*" >&2
}

log_red() {
  log_color "0;31" "$@"
}

log_blue() {
  log_color "0;34" "$@"
}

log_task() {
  log_blue "🔃" "$@"
}

log_manual_action() {
  log_red "⚠️" "$@"
}

log_error() {
  log_red "❌" "$@"
}

error() {
  log_error "$@"
  exit 1
}

sudo() {
  if [ "$(id -u)" -eq 0 ]; then
    "$@"
  else
    if ! command sudo --non-interactive true 2>/dev/null; then
      log_manual_action "Root privileges are required, please enter your password below"
      command sudo --validate
    fi
    command sudo "$@"
  fi
}

script_path=${0:a:h}
apt_updated=false
apt_update() {
  if ! $apt_updated; then
    sudo apt update --yes
    apt_updated=true
  fi
}

# install xstow if not found
if ! command -v xstow >/dev/null 2>&1; then
  log_task "Installing xstow"
  apt_update
  sudo apt install xstow --yes
fi
# install bat if not found
if ! command -v batcat >/dev/null 2>&1; then
  log_task "Installing bat"
  apt_update
  sudo apt install bat --yes
fi
# install oh-my-posh
if ! command -v oh-my-posh >/dev/null 2>&1; then
  log_task "Installing oh-my-posh"
  curl -s https://ohmyposh.dev/install.sh | sudo bash -s
  log_task "Installing nerd Font"
  oh-my-posh font install RobotoMono
fi
# install thefuck
if ! command -v thefuck >/dev/null 2>&1; then
  log_task "Installing thefuck"
  apt_update
  sudo apt install python3-dev python3-pip python3-setuptools --yes
  pip3 install thefuck --user
fi
# install fzf
if ! command -v fzf >/dev/null 2>&1; then
  log_task "Installing fzf"
  apt_update
  sudo apt install fzf --yes
fi
# install ripgrep
if ! command -v rg >/dev/null 2>&1; then
  log_task "Installing ripgrep"
  apt_update
  sudo apt install ripgrep --yes
fi
# install exa
if ! command -v exa >/dev/null 2>&1; then
  log_task "Installing exa"
  apt_update
  sudo apt install exa --yes
fi
# install helix
if ! command -v hx >/dev/null 2>&1; then
  log_task "Installing helix"
  sudo add-apt-repository ppa:maveonair/helix-editor
  sudo apt update
  sudo apt install helix --yes
fi
# install oh-my-zsh
dir="$HOME/.oh-my-zsh/"
if [ ! -d "$dir" ]; then
  log_task "Installing oh-my-zsh"
  sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)" "" --unattended
fi
# install zsh autosuggestions
dir="$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions/"
if [ ! -d "$dir" ]; then
  log_task "Installing zsh autosuggestions"
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi
# install zsh syntax highlighting
dir="$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/"
if [ ! -d "$dir" ]; then
  log_task "Installing zsh autosuggestions"
  git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi
# install zsh fzf history seach
dir="$HOME/.oh-my-zsh/custom/plugins/zsh-fzf-history-search/"
if [ ! -d "$dir" ]; then
  log_task "Installing zsh fsf history search"
  git clone https://github.com/joshskidmore/zsh-fzf-history-search ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-fzf-history-search
fi
cd $script_path
#create local git config if it does not exist
if [ ! -f "./git/.gitconfig.local" ]; then
  log_task "setting up git"
  log_manual_action "please enter your full name:"
  vared -p '' -c name
  log_manual_action "please enter your email adress:"
  vared -p '' -c email
  export name="$name"
  export email="$email"
  envsubst < gitconfig.local.template > git/.gitconfig.local
fi
# stow actual dotfiles
xstow --restow */ -f