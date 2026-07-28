#!/usr/bin/env bash
# Serve the site locally at http://localhost:4000
#
# Uses Docker so there is nothing to install beyond Docker itself. This mirrors
# how mahaloz.re is served. If you have a working local Ruby, `bundle exec
# jekyll serve` does the same thing without the container.
set -euo pipefail

docker run --rm \
  --volume="$PWD:/srv/jekyll:Z" \
  --publish 4000:4000 \
  jekyll/jekyll:4 \
  jekyll serve --host 0.0.0.0 --livereload
