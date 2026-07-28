#!/usr/bin/env bash
# Serve the site locally at http://localhost:4000
#
# Uses Docker so there is nothing to install beyond Docker itself, and runs
# through `bundle exec` so it builds with the Gemfile's github-pages versions —
# the same ones GitHub Pages uses. If you have a working local Ruby,
# `bundle exec jekyll serve --livereload` does the same thing without Docker.
#
# The plain `ruby` image is used rather than `jekyll/jekyll`, whose Alpine base
# has no C toolchain and so cannot build github-pages' native gems (rdiscount).
# Ruby is pinned to 2.7 because Jekyll 3.x — what github-pages resolves to —
# depends on webrick and other stdlib that Ruby 3 dropped.
#
# Gems live in a named Docker volume, so the first run installs them (a minute
# or two) and later runs start immediately. `docker volume rm noelo-gems`
# forces a clean reinstall.
set -euo pipefail

# Interactive TTY when there is one, so this also works from a script or CI.
tty_flags=()
[ -t 0 ] && tty_flags=(--interactive --tty)

docker run --rm "${tty_flags[@]}" \
  --volume="$PWD:/srv/jekyll:Z" \
  --volume=noelo-gems:/usr/local/bundle \
  --workdir=/srv/jekyll \
  --publish 4000:4000 \
  --publish 35729:35729 \
  ruby:2.7 \
  bash -lc "bundle install && bundle exec jekyll serve --host 0.0.0.0 --livereload"
