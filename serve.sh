#!/usr/bin/env bash
# Serve the site locally at http://localhost:4000
#
# Uses Docker so there is nothing to install beyond Docker itself, and runs
# through `bundle exec` so it builds with the Gemfile's github-pages versions —
# the same ones GitHub Pages uses. If you have a working local Ruby,
# `bundle exec jekyll serve --livereload` does the same thing without Docker.
set -euo pipefail

docker run --rm -it \
  --volume="$PWD:/srv/jekyll:Z" \
  --publish 4000:4000 \
  --publish 35729:35729 \
  jekyll/jekyll:4 \
  bash -lc "bundle install && bundle exec jekyll serve --host 0.0.0.0 --livereload"
