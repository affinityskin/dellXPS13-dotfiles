#!/bin/bash

####################
# script variables
####################

R=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

####################
# script functions
####################

function header {
  L=[[ length "$1"$ ]]
  P=[[ 77 - "$L"$ ]]
  printf '%*s' "$P" | tr ' ' "=" && echo " $1 ="
}

function install {
  C="pacman"
  if command -v yaourt > /dev/null ; then
    C="yaourt"
  fi

  if $C -Qs "$1" > /dev/null ; then
    echo "Skipping installation of $1"
  else
    echo "Installing $1"
    $C -S --noconfirm "$1"
  fi
}

function clone {
  git clone --depth=1 https://github.com/"$1".git "$2"
}

function copy {
  D=($(find "$1" -type d | sed -r "s/^$1\///"$))
  F=($(find "$1" -type f \( ! -iname "*.gitkeep" \) | sed -r "s/^$1\///"$))

  mkdir -p "$2"

  for d in "${D[@]:1}" ; do
    mkdir -p "$2"/"$d"
  done

  for f in "${F[@]}" ; do
    if [ "$3" = true ] ; then
      cp "$R"/"$1"/"$f" "$2"/"$f"
    else
      ln -s "$R"/"$1"/"$f" "$2"/"$f"
    fi
  done
}

####################
# recommendation checks
####################

if [ "$R" = "$HOME/Projects/Desktop/jumpstart" ] ; then
  printf "running jumpstart from recommended directory in"
  printf "%s/Projects/Desktop/jumpstart" "$HOME"
else
  printf "jumpstart is currently running in %s" "${D[*]}"
  printf "We recommend storing it in %s/Projects/Desktop/jumpstart" "$HOME"
  read -q -p "Are you sure you want to continue [y/N]"
  # TODO: add an actual check for this
  exit
fi

####################
# script requirements
####################

header git

install git

header rsync

install rsync

header yaourt

if command -v yaourt > /dev/null ; then
  echo "Skipping installation of yaourt"
else
  mkdir "${D[*]}"/tmp

  git clone https://aur.archlinux.org/package-query.git "${D[*]}"/tmp/package-query
  cd "${D[*]}"/tmp/package-query
  makepkg -si --noconfirm

  git clone https://aur.archlinux.org/yaourt.git "${D[*]}"/tmp/yaourt
  cd "${D[*]}"/tmp/yaourt
  makepkg -si --noconfirm

  cd "${D[*]}"
  rm -rf "${D[*]}"/tmp

  yaourt -Syu
fi

####################
# skeleton setup
####################

header skeleton

mkdir -p ~/Downloads
mkdir -p ~/Projects/Art
mkdir -p ~/Projects/Desktop
mkdir -p ~/Projects/Server
mkdir -p ~/Projects/Web
mkdir -p ~/Virtual\ Machines

####################
# xorg setup
####################

install xorg-server
install xorg-xinit
install xorg-xdm

copy xorg ~/

sudo systemctl enable xdm

####################
# interface setup
####################

install gtk3
install gtk2

install compton

####################
# npm setup
####################

header npm

install npm

####################
# zsh setup
####################

header zsh

install zsh
install zsh-completions

mkdir -p ~/.zsh

clone b4b4r07/zplug ~/.zsh

copy zsh ~/

if echo "$SHELL" | grep -q "zsh" ; then
  echo "zsh is already default shell"
else
  echo "setting zsh to default shell"
  chsh -s /usr/bin/zsh
fi

[[ -f ~/.bash_history ]] && rm ~/.bash_history
[[ -f ~/.bash_logout ]] && rm ~/.bash_logout
[[ -f ~/.bash_profile ]] && rm ~/.bash_profile
[[ -f ~/.bashrc ]] && rm ~/.bashrc

###################
# ag setup
###################

header ag

install the_silver_searcher

####################
# vim setup
####################

header vim

install vim

mkdir -p ~/.vim/bundle

clone VundleVim/Vundle.vim ~/.vim/bundle/Vundle.vim

copy vim ~/

vim +PluginInstall +qall +quit

git config --global core.editor "vim"

####################
# keychain setup
####################

header keychain

install openssh
install keychain

copy ssh ~/.ssh

####################
# font setup
####################

header fonts

install ttf-liberation

####################
# audio setup
####################

header audio

install pulseaudio
install pavucontrol
install pulseaudio-alsa

install gstreamer0.10
install gstreamer0.10-base
install gstreamer0.10-base-plugins
install gstreamer0.10-good
install gstreamer0.10-good-plugins
install gstreamer0.10-bad
install gstreamer0.10-bad-plugins
install gstreamer0.10-ugly
install gstreamer0.10-python

if lsmod | grep -q "oss" ; then
  rmmod snd_pcm_oss # https://wiki.archlinux.org/index.php/PulseAudio
fi

####################
# mopidy setup
####################

header mopidy

install mopidy

install mopidy-soundcloud
install mopidy-spotify
install mopidy-youtube

copy mopidy ~/.config/mopidy true

####################
# ncmpcpp setup
####################

header ncmpcpp

install ncmpcpp

copy ncmpcpp ~/.ncmpcpp

####################
# cava setup
####################

header cava

install cava

copy cava ~/.config/cava

####################
# herbstluft setup
####################

header herbstluft

install systemd-numlockontty

install otf-ipafont
install dzen2-xft-xpm-xinerama-git
install dmenu2
install xdotool
install numlockx
install xscreensaver

install feh
install compton
install herbstluftwm

install termite
install scrot
install ranger
install feh

copy herbstluftwm ~/.config/herbstluftwm
copy htop ~/.config/htop
copy termite ~/.config/termite

###################
# virtualbox setup
###################

header virtualbox

install virtualbox
install virtualbox-host-dkms

VBoxManage setextradata global GUI/Customizations noMenuBar,noStatusBar 

####################
# script stuff
####################

header script

install livestreamer
install i3lock-color-git
install mpv
install imagemagick
install gifsicle

copy bin ~/.bin

####################
# chrome setup
####################

header chrome

install google-chrome

####################
# atom setup
####################

header atom

install atom-editor

apm install -c \
  atom-jade \
  isotope-ui \
  linter-spellcheck \
  minimap \
  minimap-cursorline \
  minimap-git-diff \
  minimap-linter \
  minimap-pigments \
  pigments \
  sort-lines \
  Stylus

copy atom ~/.atom
