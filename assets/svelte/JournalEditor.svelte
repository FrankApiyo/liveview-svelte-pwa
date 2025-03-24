<script lang="ts">
  import { fly } from "svelte/transition";
  import { Check } from "lucide-svelte";

  import { focusTrap } from "$lib/actions/focusTrap";
  import { clickOutside } from "$lib/actions/clickOutside";

  import { openedMenuId } from "$stores/clientOnlyState";
  import { journals } from "$stores/crdtState";

  import type { Journal } from "$stores/crdtState";
  import type { UpdateItem } from "./JournalApp.svelte";

  export let item: Journal;
  export let updateItem: UpdateItem;
  export let menuClass: string;

  let newBody = item.body || "";
  let error = "";
  let isTyping = false;

  $: {
    const updatedItem = $journals.find(j => j.id === item.id);
    if (updatedItem && !isTyping) {
      newBody = updatedItem.body || "";
    }
  }

  function commitEdits() {
    updateItem({
      id: item.id,
      body: newBody,
      name: item.name,
    });

    $openedMenuId = "";
  }

  function discardEdits() {
    updateItem({
      id: item.id,
      name: item.name,
      body: item.body,
    });

    $openedMenuId = "";
  }

  function handleSubmit() {
    newBody = newBody.replace(/\s+/g, " ").trim();

    if (["", item.body].includes(newBody)) {
      discardEdits();
      return;
    }

    if (item.body.toLowerCase() === newBody.toLowerCase()) {
      commitEdits();
      return;
    }

    if (newBody.length > 50000) {
      error = "Cannot be over 50000 characters!";
      return;
    }

    commitEdits();
  }

  function handleEscape() {
    newBody = "";
    handleSubmit();
  }

  function handleInput(event: Event) {
    isTyping = true;
    const target = event.target as HTMLTextAreaElement;
    newBody = target.value;
    updateItem({ ...item, newBody });
    error = "";
  }

  function handleBlur() {
    isTyping = false;
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
    on:blur={handleBlur}
  />

  {#if error}
    <p style="word-break: break-word;" class="text-error mt-1 text-sm" in:fly={{ y: -10 }}>
      {error}
    </p>
  {/if}
</form>
