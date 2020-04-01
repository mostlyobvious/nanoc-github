# Nanoc::Github

Content source from git repository. A way to have your writing in public and open for editing while not being distracted
by static site generator trivia this content is usually mixed with.

## Usage

Add to `Gemfile` in your nanoc project:

```ruby
gem "nanoc-github"
```

Then tell nanoc to load it in `lib/default.rb`:

```ruby
require "nanoc/github"
```

At last, enable github data source in `nanoc.yaml`:

```yaml
data_sources:
  - type: github
    items_root: /posts                             # the root where items should be mounted
    repository: arkency/posts                      # organization/repository on github to use as a source of content
    encoding: utf-8                                # how to decode content                                            (default: utf-8)
    access_token: secret123                        # github access token, not required for public repositories        (default: nil)
    path: posts/                                   # subdirectory of the content in given repository                  (default: nil)
    concurrency: 10                                # how many threads to spawn to fetch data                          (default: 5)
    verbose: true                                  # show HTTP cache hit/miss on STDOUT                               (default: false)
```

## Status

[![build status](https://github.com/pawelpacana/nanoc-github/workflows/test/badge.svg)](https://github.com/pawelpacana/nanoc-github/actions)
[![gem version](https://badge.fury.io/rb/nanoc-github.svg)](https://badge.fury.io/rb/nanoc-github)
