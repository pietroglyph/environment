#!/usr/bin/env bash

# There's a command called "scrot" that works on X11; an enhanced version, which supports area selection, is called "escrotum". This is thw Wayland version.
grim -g "$(slurp)" - | wl-copy -t image/png
