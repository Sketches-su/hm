#!/bin/bash

srcmany()
{
  local a
  
  for a in "$@"; do
    source "$a"
  done
}

# ============================================================================

cd `dirname $0`

 if [ "`id -u`" -ne 0 ]; then
  echo Must be run from root!
  exit 1
fi

# Загружаем конфигурацию
source config/_general_

for a in config/*; do
  if [ "$a" != "config/_general_" ] && [ "${a: -8}" != ".example" ]; then
    source "$a"
  fi
done

# Если передан файл с необходимыми действию сведениями, подключаем его
if [ "$1" == "source" ] && [ -f "$2" ]; then
  source "$2"
fi

# Определяем действие
if [ "$action" == "" ]; then
  if [ "$1" == "" ]; then
    echo 'hm.sh {action}'
    echo '  Executes {action} in interactive mode'
    echo 'hm.sh source {file}'
    echo '  Executes action taking its name and other parameters from {file}'
    echo '  thus being intended for non-interactive job'
    exit
  fi
  
  action="$1"
fi

if [ ! -f "actions/$action" ]; then
  echo Unknown action to do
  exit 2
fi

# Запускаем действие
source "actions/$action"

