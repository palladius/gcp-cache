# README

 <img src='https://github.com/palladius/gcp-cache/raw/main/app/assets/images/PalladiusPacans_a_very_intertwined_network_of_pizza_slices_fold_014a6801-a8d0-4122-a8f9-4aa778cb089c.png' height='400' align='right' />

Built with:

* Rails `7.0.4`
* Ruby `2.7.5` (but might get to 3.x soon why not)
* Bootstrap `v5.2.3` (why oh why?)
* Database creation: TODO under `iac/`
* Database initialization: TODO
* ENV vars: `.envrc` with yours and `.envrc.dist` to copy yours from
* Plays well with: https://github.com/palladius/org-folder-projects-graph

No Services for now (job queues, cache servers, search engines, etc.)

# install

* `cp .envrc.dist .envrc` and edit away
* make run # rails s after precompiling assets, you know, CSSs...


Before you start gcloud-ing all around, you might want to make sure your gcloud config is set and also:

`gcloud auth application-default login`


## How to add/ingest data

You might want to install this code to slurp your Org.

This software works 'perfectly' with it (meaning "it works on my machine").

### Phase 1. Populate local JSONs for the big Haduken

1. Install the awesome https://github.com/palladius/org-folder-projects-graph and make sure its in the right path (../org-folder-projects-graph/) and run the org thingy on a few Orgs you own. That will create JSONs in your `../org-folder-projects-graph/.cache/`.
2. Run `make populate`. It will do A LOT of sweet things.

Look in awe: `make show-data` , it's all your stuff! Some files will be empty, I know.

### Phase 2: The big Haduken

1. Run `make seed-from-riccardo-other-script` (a form of the familiar `rake db:seed`  which sets correctly certain ENVs - this is what you change in case your installation is different path than mine). It will look for the cache dir in (1) and stuff in here populated by (2)/(3). Awesome. Dont believe me? You should.

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

and yes, this explains the logo too.

# Run

If you want to use automagic Makefile commands, please make sure to use direnv first to load all ENV correctly.
DB depends on it, and wont work without - sorry.

```bash
ricc@ricc-macbookpro3:🏡~/git/gcp-cache$ direnv allow
ricc@ricc-macbookpro3:🏡~/git/gcp-cache$ make run
```

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
* `Folders and Orgs` - Now both are conveyed in the `Folder` model. The view/controller discriminates in query/view for the Org, but lets remember that while Orgs are specials, folders cant exist without orgs (so you can visualize Org alone which have more stuff, but when you visualize folders you cant leave the orgs behind or trees become silly forests).
* See https://github.com/palladius/org-folder-projects-graph to get them out :)
* asset_inventory_items: I'll skip on data.

```json
# JSON representation of a Folder/Org (I believe)
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

  Billing Accounts:

    {
    "displayName": "Google Cloud Platform - fake Billing Account",
    "masterBillingAccount": "", # Usually empty
    "name": "billingAccounts/01AAAA-424242-C1EFC0",
    "open": true
  }

```

Actually I implemented a Schema autodetect :)

```bash
ricc@ricc-macbookpro3:🏡~/git/gcp-cache$ cat .DbSeedMagicSignature.yaml
---
:parse_project_info:
- createTime
- labels
- lifecycleState
- name
- parent
- projectId
- projectNumber
:parse_organization_info:
- creationTime
- displayName
- lifecycleState
- name
- owner
:parse_folder_info:
- createTime
- displayName
- lifecycleState
- name
- parent
```

# TODO

* add **Labels** support
* Add **Firebase** support (free for all documents vs strict Ruby/MySQL schema).

## Adding GCE VMs

add manuy labels.. and tags (1 word)
normal visualization shows this:

    NAME, ZONE, MACHINE_TYPE, PREEMPTIBLE  INTERNAL_IP     EXTERNAL_IP, STATUS

* command:

    rails g scaffold vm name:string description:text internal_notes:text machine_type:string internal_ip:string external_ip:string self_link:string zone:string disk1_size_gb:integer disk1_name:string status:string is_preemptible:boolean project:references --force

eg: gcloud --project XXXX compute instances list --format json | tee .gcloud.instances.list.project=XXXX.json


rails g scaffold service name:string gcp_tag:string priority:integer expected_status:string devconsole_url:string inventory_item:references description:text
