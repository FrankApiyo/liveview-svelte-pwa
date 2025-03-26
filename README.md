# Local-first Mental Health Journaling

![Logo](logo2.webp)

This Journaling app is a demo of an installable [Phoenix](https://www.phoenixframework.org/) Progressive Web App ([PWA](https://developer.mozilla.org/en-US/docs/Web/Progressive_web_apps)) that can sync real-time across multiple devices while also being able to work locally offline.

Learn more about the architecture of this app [here](/docs/architecture.md)

### Analytics server

- This web app also depends on an analytics server which is responsible for generating insights on user journaling
- Please read more about the analytics server [here](https://github.com/FrankApiyo/journal_analytics)
- The analytics server utilizes API endpoints whose documentation can be accessed once the server is running [here](http://localhost:4000/swaggerui)

## Running Locally

You can run this app locally by following the steps below after cloning the repo.

0. [Install elixir and erlang](https://elixir-lang.org/install.html#gnulinux)
1. Install the Phoenix dependencies.

```sh

mix deps.get
```

2. Install the Node.js dependencies. The `--prefix assets` is required when running
the command from the root directory in order to install the dependencies in the
`assets` directory.

```sh
npm install --prefix assets
```

3. Create the database.

```sh
docker compose up
mix ecto.create
```

4. Start the Phoenix server.

```sh
mix phx.server
```

5. Adding pre-commit hooks.

```bash
mkdir -p .git/hooks
echo '#!/bin/sh
# Get the Git root directory
GIT_ROOT=$(git rev-parse --show-toplevel)
# Change to assets directory
cd "$GIT_ROOT/assets" || exit 1
# Run Prettier
npx prettier --write .
# Change back to Git root
cd "$GIT_ROOT" || exit 1
# Run mix format
mix format
' > .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit
```

## Technologies Used

- Phoenix [LiveView](https://github.com/phoenixframework/phoenix_live_view),
  [PubSub](https://hexdocs.pm/phoenix/channels.html#pubsub), and
  [Ecto](https://github.com/elixir-ecto/ecto/tree/v3.11.1)/[PostgreSQL](https://www.postgresql.org/)
  for real-time syncing and data persistence.
- [Svelte](https://svelte.dev/) (via [LiveSvelte](https://github.com/woutdp/live_svelte))
  for the frontend UI and state management.
- [Service Workers](https://developer.mozilla.org/en-US/docs/Web/API/Service_Worker_API),
  [Web Storage](https://developer.mozilla.org/en-US/docs/Web/API/Web_Storage_API), and
  [IndexedDB](https://developer.mozilla.org/en-US/docs/Web/API/IndexedDB_API)
  (via [y-indexeddb](https://github.com/yjs/y-indexeddb)) for offline support.
- [CRDTs](https://crdt.tech/) (via [Yjs](https://github.com/yjs/yjs)) to resolve conflicts between
  distributed app states.
- [Wallaby](https://github.com/elixir-wallaby/wallaby) to run integration tests

## Todos

- [X] Add some pre-commit hooks to run the following:
  - [X] `mix format`
  - [X] `npx prettier --write .`
- [x] Add APIs with Django
  - [x] Add new tables for Journals
  - [X] Add API endpoint to get JSON journals
  - [X] Add API authentication
  - [X] Add some simplistic RBAC
- [x] Fix issue with syncing to the text area
- [x] Remove `syncing` from settings page
- [x] Look into a better field type for documents in PostgreSQL
- [x] Visualizations
  - [x] Wordcloud
- [ ] Deployment & Documentation
  - [ ] Include scanning with trivy as a sec. measure
  - [ ] Add bot and webcrawler detection and prevention strategies
  - [ ] Add some unit tests for svelte fns (night)
- [ ] More FE tests
- [ ] Research on how to always make sure that a PWA JS is always up to date
- [ ] Remove dev secrets from repo
- [ ] More Wallaby tests (nights)
