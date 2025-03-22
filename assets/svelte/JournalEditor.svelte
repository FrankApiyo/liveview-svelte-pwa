<script lang="ts">
  import { fly } from "svelte/transition";
  import { Check } from "lucide-svelte";

  import { focusTrap } from "$lib/actions/focusTrap";
  import { clickOutside } from "$lib/actions/clickOutside";

  import { openedMenuId } from "$stores/clientOnlyState";

  import type { Journal } from "$stores/crdtState";
  import type { UpdateItem } from "./TodoApp.svelte";

  export let item: Journal;
  export let updateItem: UpdateItem;
  export let menuClass: string;

  let newBody = item.body || "";
  let error = "";

  /**
   * Commit edits made to the item and close the edit form.
   */
  function commitEdits() {
    updateItem({
      id: item.id,
      body: newBody,
      name: item.name,
    });

    $openedMenuId = "";
  }

  /**
   * Discard edits made to the item and close the edit form.
   */
  function discardEdits() {
    updateItem({
      id: item.id,
      name: item.name,
      body: item.body,
    });

    $openedMenuId = "";
  }

  function handleSubmit() {
    // Trim whitespace.
    body = newBody.replace(/\s+/g, " ").trim();

    // Check if new item name is empty string or unchanged.
    if (["", item.body].includes(newBody)) {
      discardEdits();
      return;
    }

    // Check if new item name is a change in casing of the original name.
    if (item.body.toLowerCase() === newBody.toLowerCase()) {
      commitEdits();
      return;
    }

    // Check if string is too long.
    if (newBody.length > 50000) {
      error = "Cannot be over 50000 characters!";
      return;
    }

    commitEdits();
  }

  /**
   * Allow the user to cancel the edit by pressing the escape key.
   */
  function handleEscape() {
    newBody = "";
    handleSubmit();
  }

  function handleInput() {
    // Track the body so that page refreshes don't reset the input value.
    updateItem({ ...item, newBody });

    // Reset error message.
    error = "";
  }
</script>

<form
  class="{menuClass} w-full h-full"
  on:submit|preventDefault={handleSubmit}
  use:clickOutside={handleSubmit}
  use:focusTrap={{
    focusFirstElement: true,
    onEscape: handleEscape,
  }}
>
  <textarea
    data-focusindex="0"
    class="
        input input-bordered border-neutral w-full join-item h-full
        focus:outline-none focus:ring-1 focus:ring-accent focus:ring-inset
      "
    placeholder="Start writing your journal entry here..."
    bind:value={newBody}
    on:input={handleInput}
  />

  {#if error}
    <p style="word-break: break-word;" class="text-error mt-1 text-sm" in:fly={{ y: -10 }}>
      {error}
    </p>
  {/if}
</form>
