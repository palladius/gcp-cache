# README

Built with:
* Rails `7.0.4`
* Ruby `2.7.5` (but might get to 3.x soon why not)
* Bootstrap `v5.2.3`

* Database creation: TODO under `iac/`
* Database initialization
* ENV vars: `.envrc` with yours and `.envrc.dist` to copy yours from

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

# install

* `cp .envrc.dist .envrc`
* edit away
* rails s

# Deployment

TODO(ricc): skaffold and CB and CD.

# Install from scratch

I'd like to make this project re-creatable as much as possible, so I'll keep in `Makefile` / `README.md` a skeleton of things to do.

## NEW

* v1. rails new gcp-cache
* v2 `rails new gcp-cache -j esbuild --css bootstrap`. As per this article: https://mixandgo.com/learn/ruby-on-rails/how-to-install-bootstrap

# Models

* `Projects` - DONE
* `Folders and Orgs` - I'd like to have a similar foirmat to project so i get a SINGLE table and its easy to do parental control :) . Let me see how the two DBs look like and diff them intelligently.
* See https://github.com/palladius/org-folder-projects-graph to get them out :)

# TODO 

* add Labels support