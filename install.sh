#!/bin/bash

unameOut="$(uname -s)"

case "${unameOut}" in
    Linux*)     machine='Linux';;
    Darwin*)    machine='Mac';;
    *)          machine='unknown';;
esac

if [[ $machine == "Linux"  ]]
then
  # TODO: Don't assume Ubuntu
  installer="apt install"
elif [[ $machine == "Mac" ]]
then
  rosetta=$(sysctl -in sysctl.proc_translated)

  if [[ $rosetta == 1 ]]
  then
    installer="arch -arm64 brew install"
  else
    installer="brew install"
  fi
else
  installer="unknown"
fi

install () {
  if [[ $installer == 'unknown' ]];
  then
    echo "Could not identify package manager to install \`$1'."
    return 1
  else
    eval "$installer $1 > /dev/null"
  fi
}


install_if_not_found () {
  if ! command -v "$1" &> /dev/null
  then
    echo "Command \`$1' could not be found. Attempting installation..."
    install "$1"

    if [[ $? == 1 ]] && [[ $1 == 'stow' ]]
    then
      echo "This script requires \`stow' to be installed and it could not be achieved automatically."
      exit 1
    fi

  else
    echo "Found program \`$1'."
  fi
}

install_if_not_found "stow"

for path in ./*; do
  [ -d "${path}" ] || continue # if not a directory, skip
  dirname="$(basename "${path}")"
  install_if_not_found "$dirname"
  echo "Creating links for $dirname..."
  stow -t $HOME $dirname
done
