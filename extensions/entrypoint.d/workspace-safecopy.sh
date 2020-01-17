#!/usr/bin/env bash

# With this extension you can mount a workspace to /safe-workspace instead to 
# /workspace. The content of /safe-workspace will be copied to /workspace and 
# you will work on a safe copy instead on the original data. If /workspace has
# any content already, no data will be copied or updated.
#
# Consider mounting the safe workspace as read-only.
#
# Cave: Every change on the data in /workspace will be lost after the container
# is removed unless you define /workspace as volume!

SAFE_WORKSPACE=/safe-workspace

[ ! -d "$SAFE_WORKSPACE" ] && return

# Copy safe workspace content to workspace directory if
# - $SAFE_WORKSPACE is not empty AND
# - $WORKSPACE is empty.
if [[ "$(ls -A "$SAFE_WORKSPACE")" ]]; then
	if [[ "$(ls -A "$WORKSPACE")" ]]; then
		>&2 echo "Skip copying of safe workspace since target workspace dir is not empty."
	else
		echo "Copying safe workspace ..."
		rsync -a --info=progress2 "$SAFE_WORKSPACE/" "$WORKSPACE/"
	fi
else
	echo "Safe workspace is empty."
fi
