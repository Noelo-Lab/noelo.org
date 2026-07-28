# noelo.org

The website for the Noelo lab at the University of Georgia. A [Jekyll](https://jekyllrb.com)
site, so GitHub Pages builds and deploys it on push with no extra setup.

## Running it locally

```sh
./serve.sh          # Docker, nothing to install — http://localhost:4000
bundle exec jekyll serve --livereload   # if you have a working local Ruby
```

## Writing a blog post

Drop a markdown file in `_posts/` named `YYYY-MM-DD-some-slug.md`:

```markdown
---
layout: post
title: "What a decompiler owes you"
date: 2026-07-24
author: mahaloz
description: >-
  One or two sentences. Shows up under the title and in the post list.
---

Body goes here, in normal markdown.
```

Everything after the front matter is markdown: headings, lists, links, tables,
blockquotes, and fenced code blocks with syntax highlighting.

### Authors

`author:` is a key from `_data/authors.yml`. To add someone:

```yaml
newperson:
  name: "Their Name"
  role: "Ph.D. Student"
  url: "https://their-site.example"
  avatar: "/assets/images/authors/newperson.jpg"   # optional
```

Only `name` is required. Without an `avatar`, the byline falls back to the ring
mark. Drop avatar images in `assets/images/authors/` — square, 200×200 or larger.

## Editing the rest of the site

| What | Where |
| --- | --- |
| Header nav, contact details, address | `_config.yml` (`nav_pages`, `email`, `city`, …) |
| Home page: hero, research thrusts, news | `index.html` |
| Papers and projects | `research.html` |
| News and updates | `_data/news.yml` (the page and both feeds read from it) |
| Lab members and open positions | `people.html` |
| How to apply | `join.html` |
| All styling | `assets/css/main.css` |

## Adding a news item

Append to `_data/news.yml` — order does not matter, the site sorts by date:

```yaml
- date: 2026-09-01
  text: "Something happened."
  link: "/research/"        # optional
  link_text: "read more"    # optional
```

That one entry feeds three places: the top three on the home page, the full
`/news/` page, and the Atom feed at `/news/feed.xml`. Blog posts have their own
feed at `/feed.xml`.

## Brand

- Red `#B80D1E`, sampled from the mark. Ink `#141110`. Warm neutrals throughout.
- Display type: [Jost](https://github.com/indestructible-type/Jost) (OFL), chosen
  to match the geometry of the wordmark.
- Everything else: [Roboto Mono](https://fonts.google.com/specimen/Roboto+Mono)
  (Apache 2.0). Both are subset and self-hosted in `assets/fonts/` — no CDN.
- Logo files are derived from `lab-assets`, with the white background keyed out
  so they sit on any surface. `wordmark-rev.png` is the reversed version used in
  the dark footer.
