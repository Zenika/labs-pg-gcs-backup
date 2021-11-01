#!/usr/bin/env bash
set -Eeou pipefail

if [ "$1" = "backup" ]; then
  sh -c "./backup.sh"
elif [ "$1" = "restore" ]; then
  echo "Restore"
else
  echo "Unrecognized command: $1"
  exit 1
fi
