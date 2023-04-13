# README

 <img src='https://github.com/palladius/gcp-cache/raw/main/app/assets/images/PalladiusPacans_a_very_intertwined_network_of_pizza_slices_fold_014a6801-a8d0-4122-a8f9-4aa778cb089c.png' height='300' align='right' />

Built with:

* Rails `7.0.4`
* Ruby `2.7.5` (but might get to 3.x soon why not)
* Bootstrap `v5.2.3` (why oh why?)
* Database creation: TODO under `iac/`
* Database initialization: TODO
* ENV vars: `.envrc` with yours and `.envrc.dist` to copy yours from
* No Services for now (job queues, cache servers, search engines, etc.)

# install

* `cp .envrc.dist .envrc` and edit away
* make run # rails s after precompiling assets, you know, CSSs...


Before you start gcloud-ing all around, you might want to make sure your gcloud config is set and also:

`gcloud auth application-default login`


## How to add/ingest data

You might want to install this code to slurp your Org.

This software works 'perfectly' with it (meaning "it works on my machine").

1. Install the awesome https://github.com/palladius/org-folder-projects-graph and make sure its in the right path (../org-folder-projects-graph/) and run the org thingy on a few Orgs you own. That will create JSONs in your `../org-folder-projects-graph/.cache/`.
2. Run `bin/gcloud-generate-info.sh` 
3. Run `bin/populate-stuff-from-gcloud.sh`
4. Look in awe: `find db -name \*.json | xargs ls -al` , its all your stuff! Some files will be empty, I know.
5. Re-run `rake db:seed` or better `make seed-from-riccardo-other-script`. It will look for the cache dir in (1) and stuff in here populated by (2)/(3). Awesome. Dont believe me? You should.

See if you get any data with `make show-data`. Sample result:

```bash
$ make show-data
👀 Showing data in your local folder..
100      db/fixtures/bq-exports/assets-export.20230413.json
6        db/fixtures/gcloud/folders-of-824879804362-20230413-174052.json
7        db/fixtures/gcloud/organizations.json
5        db/fixtures/gcloud/projects-20230413-171841.json
6        db/fixtures/gcloud/folders-of-824879804362-20230413-171842.json
5        db/fixtures/gcloud/projects-20230413-174050.json
7069     db/fixtures/gcloud/gcloud-projects-list-20230131-172133.json
1        db/fixtures/org-folder-projects-graph/projects/projects-childrenof-887288965373.json

👀 Lets now ask Rails DB:
Loading development environment (Rails 7.0.4.2)
Switch to inspect mode.
"🍕 #{Project.count} Projects 📂 #{Folder.count_folders} Folders 🗂️  #{Folder.count_orgs} Orgs"
"🍕 529 Projects 📂 108 Folders 🗂️  22 Orgs"

👀 DONE 
```

### What does `org-folder-projects-graph` do anyway?

If you go in that directory and you run somethingf like:

```bash
$ ruby recurse_folders.rb ricc.rocks
🌲 299061907367 # 'ricc.rocks'
├─ 🍕 terraform-cazzabubbole (1039796170497)
├─ 🍕 tfws-1679136190825 (333456123049)
├─ 🍕 tfws-1679136020726 (938196778246)
├─ 🍕 quiet-chalice-381010 (1075875814806)
├─ 🍕 terraform-base-381009 (226074418116)
```

Plus, the script will create a bunch of JSONs in .cache/ which this script reuses. 

Genius!

# Deployment

TODO(ricc): skaffold and CB and CD.

* `skaffold dev`: WIP

# Install from scratch

I'd like to make this project re-creatable as much as possible, so I'll keep in `Makefile` / `README.md` a skeleton of things to do.

## NEW

* v1. rails new gcp-cache
* v2 `rails new gcp-cache -j esbuild --css bootstrap`. As per this article: https://mixandgo.com/learn/ruby-on-rails/how-to-install-bootstrap

# Models

This is me documenting how all the *ambaradan* works. Currently there are some bugs so some imports do NOt work. sorry.

* `Projects` - DONE
* `Folders and Orgs` - I'd like to have a similar format to project so i get a SINGLE table and its easy to do parental control :) . Let me see how the two DBs look like and diff them intelligently.
* See https://github.com/palladius/org-folder-projects-graph to get them out :)
* asset_inventory_items: I'll skip on data.

```json
{
 "version": string,
  "discoveryDocumentUri": string,
  "discoveryName": string,
  "resourceUrl": string,
  "parent": string,
  "data": {
    object
  },
  "location": string
  }
```

# TODO 

* add **Labels** support
* Add **Firebase** support (free for all documents vs strict Ruby/MySQL schema).