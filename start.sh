#!/bin/sh

set -e
usermod --uid $UID minecraft
groupmod --gid $GID minecraft

if [ "$SKIP_OWNERSHIP_FIX" != "TRUE" ]; then
  fix_ownership() {
    dir=$1
    if ! sudo -u minecraft test -w $dir; then
      echo "Correcting writability of $dir ..."
      chown -R minecraft:minecraft $dir
      chmod -R u+w $dir
    fi
  }

  fix_ownership /data
  fix_ownership /data/world
  fix_ownership /data/world_the_end
  fix_ownership /data/world_nether
  fix_ownership /home/minecraft
fi

echo "Switching to user 'minecraft'"
exec sudo -E -u minecraft /start-minecraft "$@"
