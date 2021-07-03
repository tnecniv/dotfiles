#!/bin/bash

if command -v apt &> /dev/null
then
  installer="apt install"
elif command -v brew &> /dev/null
then
  installer="brew install"
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

for path in ./*; do
  [ -d "${path}" ] || continue # if not a directory, skip
  dirname="$(basename "${path}")"
  install_if_not_found "$dirname"
  echo "Creating links for $dirname..."
  stow -t $HOME $dirname
done
