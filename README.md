# Guild Wars Tracker

A Rails application for importing Guild Wars campaign and quest metadata from the official wiki, then browsing it by campaign or in one catalogue.

## Requirements

- Ruby `4.0.5` (see `.ruby-version`)
- PostgreSQL 14 or newer running locally
- Bundler

## Setup

```sh
bin/setup
```

`bin/setup` installs Ruby dependencies, prepares the development database, and starts the development process. To set up without starting the server, run:

```sh
bin/setup --skip-server
```

Visit `http://localhost:3000` once the server is running.

## Importing wiki data

Import the campaign index and available quest pages with:

```sh
bin/rails gw:import
```

The importer is safe to run again: campaigns and quests are upserted using their wiki-derived identities. A failed campaign is reported while the importer continues with the remaining campaigns.

## Development checks

```sh
bin/rails test
bin/rubocop
bin/brakeman --quiet --no-pager
bin/ci
```

`bin/ci` runs setup, style, security, tests, and seed checks. It requires PostgreSQL and network access for the advisory audit.

## Deployment

The included Dockerfile produces a production image. It expects `RAILS_MASTER_KEY` at runtime and follows the Kamal configuration in `config/deploy.yml`.
