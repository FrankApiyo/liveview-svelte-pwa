<script lang="ts">
  import { flip } from "svelte/animate";
  import { fade } from "svelte/transition";
  import { ChevronRight } from "lucide-svelte";
  import { dndzone } from "svelte-dnd-action";
  import * as Y from "yjs";

  import { onKeydown } from "$lib/actions/onKeydown";
  import { useHasTouchScreen } from "$lib/hooks/useHasTouchScreen";

  import { itemToProcessId, openedMenuId, selectedListId, urlHash } from "$stores/clientOnlyState";
  import { journals, yJournals } from "$stores/crdtState";

  import DragHandle from "./DragHandle.svelte";
  import EditForm from "./EditForm.svelte";
  import OptionsMenu from "./OptionsMenu.svelte";

  import type { Journal } from "$stores/crdtState";
  import type { DeleteItem, DndHandler, UpdateItem } from "./JournalApp.svelte";

  export let updateItem: UpdateItem;
  export let deleteItem: DeleteItem;
  export let handleConsider: DndHandler;
  export let handleFinalize: DndHandler;
  export let handleDragKeyDown: (event: KeyboardEvent, itemId: string) => void;
  export let dragDisabled: boolean;
  export let flipDurationMs: number;
  export let menuClass: string;
  export let confirmDeletionModalId: string;
  export let isScrollPositionRestored: boolean;

  const hasTouchScreen = useHasTouchScreen();

  function updateUiOnConsider(newItems: Journal[]) {
    $journals = newItems;
  }

  function updateUiOnFinalize(newItems: Journal[]) {
    const oldIndex = $yJournals.toArray().findIndex((yMap) => yMap.get("id") === $itemToProcessId);

    const oldList = $yJournals.get(oldIndex);
    const newList = new Y.Map<string>();

    let oldListId = oldList.get("id");
    if (typeof oldListId !== "string") {
      throw new Error("The journal ID must be a string.");
    }

    let oldListName = oldList.get("name");
    if (typeof oldListName !== "string") {
      throw new Error("The journal name must be a string.");
    }

    let oldListBody = oldList.get("body");
    if (typeof oldListBody !== "string") {
      throw new Error("The journal name must be a string.");
    }

    newList.set("id", oldListId);
    newList.set("name", oldListName);
    newList.set("body", oldListBody);

    $yJournals.doc.transact(() => {
      $yJournals.delete(oldIndex);

      // Move the journal to the new position.
      const index = newItems.findIndex((journal) => journal.id === $itemToProcessId);
      $yJournals.insert(index, [newList]);
    });
  }
</script>

<ul
  class="
    min-h-[40px] rounded-lg
    focus:outline-none focus-visible:ring ring-accent ring-offset-1 ring-offset-base-100
  "
  style:visibility={isScrollPositionRestored ? "visible" : "hidden"}
  aria-label="Lists"
  use:dndzone={{
    items: $journals,
    flipDurationMs,
    dragDisabled,
    morphDisabled: true,
    dropTargetStyle: {},
    dropTargetClasses: ["border-2", "border-dashed", "rounded-lg", "border-accent"],
  }}
  on:consider={(event) => handleConsider(event, updateUiOnConsider)}
  on:finalize={(event) => handleFinalize(event, updateUiOnFinalize)}
>
  {#each $journals as journal (journal.id)}
    <li
      class="
        flex items-center justify-between rounded-lg
        focus:outline-none focus-visible:ring ring-accent ring-offset-1 ring-offset-base-100
      "
      aria-label={journal.name}
      animate:flip={{ duration: flipDurationMs }}
      use:onKeydown={(event) => handleDragKeyDown(event, journal.id)}
    >
      {#if journal.isEditing}
        <EditForm item={journal} {updateItem} {menuClass} />
      {:else}
        <button
          title="Click to view journal."
          class="
            flex items-center gap-1 grow px-2 py-1.5 mr-5 rounded-lg
            text-lg text-left active:bg-base-300
            focus:outline-none focus-visible:ring ring-accent ring-offset-1 ring-offset-base-100
          "
          class:pointer-events-none={$openedMenuId}
          class:hover:bg-base-200={!hasTouchScreen}
          on:click={() => {
            $urlHash = "journalId";
            $selectedListId = journal.id;
            history.pushState({}, "", `/app#${journal.id}`);
            window.scrollTo(0, 0);
          }}
        >
          <span style="word-break: break-word;">
            {journal.name}

            <span class="badge badge-xs transition-none p-2"> 0 / 0 </span>
          </span>

          <ChevronRight class="shrink-0 w-4 h-4" />
        </button>

        <div class="flex gap-1">
          <OptionsMenu item={journal} {updateItem} {deleteItem} {menuClass} {confirmDeletionModalId} />

          <DragHandle bind:dragDisabled itemId={journal.id} />
        </div>
      {/if}
    </li>
  {:else}
    <li
      class="
        flex items-center h-10 px-2 rounded-lg
        focus:outline-none focus-visible:ring ring-accent ring-offset-1 ring-offset-base-100
      "
      in:fade={{ delay: 250 }}
    >
      No Journal yet. Please create a Journal to get started
    </li>
  {/each}
</ul>
