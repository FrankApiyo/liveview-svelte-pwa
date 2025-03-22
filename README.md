# Local-First LiveView Svelte Journaling App

This Journaling app is a demo of an installable [Phoenix](https://www.phoenixframework.org/)
Progressive Web App ([PWA](https://developer.mozilla.org/en-US/docs/Web/Progressive_web_apps))
that can sync real-time across multiple devices while also being able to work locally offline.

## Running Locally

You can run this app locally by following the steps below after cloning the repo.

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

## Deploying the Project

To deploy this app to [Fly.io](https://fly.io/), run the following commands.
**Note:** You will need to have an account with Fly and
[`flyctl`](https://fly.io/docs/hands-on/install-flyctl/) installed.

1. Remove the `fly.toml` file. A new one will be created when you run `fly launch`.

```sh
rm fly.toml
```

2. Initialize and deploy the project. Fly will automatically detect the app type
and set up the necessary configuration. You can tweak the settings or stick with
the defaults, but make sure that a Postgres database is included in the
configuration settings.

```sh
fly launch
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
- [ ] Add APIs
  - [ ] Add new tables for Journals
  - [ ] Add async tasks to sync to these tables
  - [ ] Add API authentication
  - [ ] Add some simplistic RBAC
- [ ] Visualizations
  - [ ] Analytical summarization of journal entries
  - [ ] Word map
- [ ] Categorization
- [ ] Deployment & Documentation
  - [ ] Include scanning with trivy as a sec. measure
  - [ ] Add bot and webcrawler detection and prevention strategies
- [ ] More Wallaby tests (nights)
