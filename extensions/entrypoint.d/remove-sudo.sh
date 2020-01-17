#!/usr/bin/env bash

# This extension removes `sudo`.

sudo pacman -R --noconfirm sudo
# just in case:
sudo rm -f "$(which sudo)"
