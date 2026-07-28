source "https://rubygems.org"

# This is what GitHub Pages actually builds the site with (currently Jekyll
# 3.10 plus the whitelisted plugins, including jekyll-seo-tag and jekyll-feed).
# Pinning it here keeps a local `bundle exec jekyll serve` on the same versions
# as production instead of a Jekyll 4 that would quietly drift from it.
gem "github-pages", group: :jekyll_plugins

# Windows and JRuby do not include zoneinfo files.
platforms :mingw, :x64_mingw, :mswin, :jruby do
  gem "tzinfo", ">= 1", "< 3"
  gem "tzinfo-data"
end
