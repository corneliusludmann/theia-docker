#!/usr/bin/env bash

# fixuid: Go binary to change Docker container user/group and file permissions at runtime
# after the eval, UID/GID match user/group, $HOME is set to user's home directory
# see: https://github.com/boxboat/fixuid
eval "$(fixuid -q)"

# Execute scripts in /entrypoint.d/
[ -d "/entrypoint.d" ] && for file in /entrypoint.d/*.sh; do source "$file"; done

# Start Theia
exec node /opt/theia/src-gen/backend/main.js /workspace --hostname=0.0.0.0
