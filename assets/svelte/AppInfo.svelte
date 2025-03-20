<script lang="ts">
  import { faGithub } from "@fortawesome/free-brands-svg-icons";
  import Fa from "svelte-fa";

  import Link from "./Link.svelte";

  import { Live } from "live_svelte";

  export let live: Live = undefined;
  live;

  export let showAuthLinks = false;
</script>

<div class="max-w-md mx-auto px-4 md:p-0">
  <h1 class="text-5xl font-black my-5">Local-First LiveView Svelte Journaling App</h1>

  <p>
    This Journaling app is a demo of an installable
    <Link href="https://www.phoenixframework.org/" external>Phoenix</Link>
    Progressive Web App (<Link
      href="https://developer.mozilla.org/en-US/docs/Web/Progressive_web_apps"
      external
    >
      PWA</Link
    >) that can sync real-time across multiple devices while also being able to work locally
    offline.
  </p>

  {#if showAuthLinks}
    <h2 class="text-3xl font-bold my-3">Try it out</h2>

    <ul class="flex gap-2">
      <li>
        <a href={"/users/register"} class="btn btn-accent border border-neutral">Register</a>
      </li>
      <li>
        <a href={"/users/log_in"} class="btn btn-accent border border-neutral">Log in</a>
      </li>
    </ul>
  {/if}

  <div class="my-6">
    <h2 class="text-3xl font-bold my-3">Technologies used</h2>

    <ul class="list-disc pl-4">
      <li>
        Phoenix
        <Link href="https://github.com/phoenixframework/phoenix_live_view" external>LiveView</Link>,
        <Link href="https://hexdocs.pm/phoenix/channels.html#pubsub" external>PubSub</Link>, and
        <Link href="https://github.com/elixir-ecto/ecto/tree/v3.11.1" external>Ecto</Link>/<Link
          href="https://www.postgresql.org/"
          external
        >
          PostgreSQL
        </Link> for real-time syncing and data persistence.
      </li>

      <li>
        <Link href="https://svelte.dev/" external>Svelte</Link>
        (via <Link href="https://github.com/woutdp/live_svelte" external>live_svelte</Link>) for the
        frontend UI and state management.
      </li>

      <li>
        <Link href="https://developer.mozilla.org/en-US/docs/Web/API/Service_Worker_API" external
          >Service Workers</Link
        >,
        <Link href="https://developer.mozilla.org/en-US/docs/Web/API/Web_Storage_API" external>
          Web Storage</Link
        >, and
        <Link href="https://developer.mozilla.org/en-US/docs/Web/API/IndexedDB_API" external>
          IndexedDB
        </Link>
        (via <Link href="https://github.com/yjs/y-indexeddb" external>y-indexeddb</Link>) for
        offline support.
      </li>

      <li>
        <Link href="https://crdt.tech/" external>CRDTs</Link>
        (via <Link href="https://github.com/yjs/yjs" external>Yjs</Link>) to resolve conflicts
        between distributed app states.
      </li>
    </ul>
  </div>

  <div class="my-6">
    <h2 class="text-3xl font-bold my-3">Contact</h2>
    <Link href="mailto:franklineapiyo@gmail.com" external>franklineapiyo@gmail.com</Link>.
  </div>

  <div class="my-6">
    <h2 class="text-3xl font-bold my-3">Source Code</h2>
    <a
      href="https://github.com/frankApiyo/liveview-svelte-pwa"
      aria-label="Github"
      target="_blank"
      rel="noopener noreferrer"
      class="
        inline-block hover:opacity-75 rounded-lg
        focus:outline-none focus-visible:ring ring-accent ring-offset-1 ring-offset-base-100
      "
    >
      <Fa icon={faGithub} size="3x" />
    </a>
  </div>
</div>
