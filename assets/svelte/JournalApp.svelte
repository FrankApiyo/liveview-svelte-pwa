<script lang="ts" context="module">
  export type DeleteItem = (item: Journal) => void;

  export type DndHandler = (event: CustomEvent, updateUi: (newItems: Journal[]) => void) => void;

  export type UpdateItem = (newItem: Journal) => void;
</script>

<script lang="ts">
  import { SOURCES, TRIGGERS } from "svelte-dnd-action";
  import * as Y from "yjs";

  import {
    isListsOpened,
    isJournalOpened,
    itemToProcessId,
    newList,
    newJournal,
    openedMenuId,
    selectedListId,
  } from "$stores/clientOnlyState";
  import { journals, yJournals } from "$stores/crdtState";
  import { liveView } from "$stores/liveViewSocket";

  import { syncDocumentToServer } from "./StateManagement.svelte";
  import ConfirmDeletionModal from "./ConfirmDeletionModal.svelte";
  import ItemsContainer from "./ItemsContainer.svelte";
  import NewItemForm from "./NewItemForm.svelte";
  import JournalEditor from "./JournalEditor.svelte";
  import JournalSelector from "./JournalSelector.svelte";

  import type { Journal } from "$stores/crdtState";

  export let menuClass: string;
  export let isScrollPositionRestored: boolean;

  const confirmDeletionModalId = "confirm-deletion-modal-id";
  const flipDurationMs = 100;
  let dragDisabled = true;

  // Journal list handlers ___________________________________________________________________________
  function addList() {
    const list = new Y.Map<string>();
    list.set("id", crypto.randomUUID());
    list.set("name", $newList);
    $yJournals.unshift([list]);

    $newList = "";

    syncDocumentToServer($liveView);
  }

  function updateJournal() {
    return;
  }

  // Shared handlers for both todo lists and todo items ____________________________________________

  const updateItem: UpdateItem = (newItem) => {
    for (const yList of $yJournals) {
      if (yList.get("id") === newItem.id) {
        $yJournals.doc.transact(() => {
          yList.set("name", newItem.name);

          newItem.newName === undefined || newItem.newName === ""
            ? yList.delete("newName")
            : yList.set("new", newItem.newName);

          newItem.newBody === undefined || newItem.newBody === ""
            ? yList.delete("newBody")
            : yList.set("body", newItem.newBody);

          newItem.isEditing === undefined
            ? yList.delete("isEditing")
            : yList.set("isEditing", newItem.isEditing);
        });

        syncDocumentToServer($liveView);
        return;
      }
    }
  };

  const deleteItem: DeleteItem = (item) => {
    for (const yList of $yJournals) {
      if (yList.get("id") === item.id) {
        $yJournals.doc.transact(() => {
          $yJournals.delete(index);
        });

        syncDocumentToServer($liveView);
        return;
      }
      index++;
    }
  };

  // Drag and drop handlers ________________________________________________________________________

  const handleConsider: DndHandler = (event, updateUiOnConsider) => {
    // Update the items list in the UI.
    const newItems = filterDuplicates(event.detail.items);
    updateUiOnConsider(newItems);

    // Ensure dragging is stopped on drag finish via keyboard.
    const { source, trigger } = event.detail.info;
    if (source === SOURCES.KEYBOARD && trigger === TRIGGERS.DRAG_STOPPED) {
      dragDisabled = true;
    }
  };

  const handleFinalize: DndHandler = (event, updateUiOnFinalize) => {
    // Update the items list in the UI.
    // TODO: Is it necessary to check that the id is reset back from the
    // svelte-dnd-action placeholder id? If the id is not reset, then
    // it is possible to have duplicate ids which will crash the app.
    const newItems = filterDuplicates(event.detail.items);
    updateUiOnFinalize(newItems);

    // Ensure dragging is stopped on drag finish via pointer (mouse, touch)
    const { source } = event.detail.info;
    if (source === SOURCES.POINTER) {
      dragDisabled = true;
    }

    // Save to server.
    syncDocumentToServer($liveView);
  };

  /**
   * Helper function to remove any items with duplicate ids from the items array.
   */
  function filterDuplicates(items: Journal[]) {
    const ids: string[] = [];

    return items.filter((item) => {
      if (!ids.includes(item.id)) {
        ids.push(item.id);
        return true;
      }
      return false;
    });
  }

  /**
   * Handle keydown events for drag and drop.
   */
  function handleDragKeyDown(event: KeyboardEvent, itemId: string) {
    // Allow Enter and Space keys to start drag and drop.
    if ((event.key === "Enter" || event.key === " ") && dragDisabled) {
      dragDisabled = false;

      // Track which item is being dragged.
      $itemToProcessId = itemId;
    }
  }

  // Keep selected list name and items in sync with selected list id _______________________________

  function setSelectedListName(listId: string) {
    return $journals.find((list) => list.id === listId)?.name ?? "";
  }
  $: selectedListName = setSelectedListName($selectedListId);
  $: selectedJournal = $journals.find((item) => item.id === $selectedListId);
</script>

{#if $itemToProcessId && $openedMenuId === confirmDeletionModalId}
  <ConfirmDeletionModal listId={$itemToProcessId} {menuClass} {deleteItem} />
{/if}

{#if $selectedListId}
  <ItemsContainer
    title={selectedListName}
    totalCount={0}
    uncompletedCount={0}
    bind:isDropdownOpened={$isJournalOpened}
    {isScrollPositionRestored}
  >
    <JournalEditor item={selectedJournal} {updateItem} {menuClass} />
  </ItemsContainer>
{:else}
  <NewItemForm
    addItemCallback={addList}
    bind:value={$newList}
    placeholder="Enter journal title"
    submitButtonText="Create"
    submitButtonTitle="Create new list."
    {isScrollPositionRestored}
  />

  <ItemsContainer
    title="Journals"
    totalCount={0}
    bind:isDropdownOpened={$isListsOpened}
    {isScrollPositionRestored}
  >
    <JournalSelector
      {updateItem}
      {deleteItem}
      {handleConsider}
      {handleFinalize}
      {handleDragKeyDown}
      bind:dragDisabled
      {flipDurationMs}
      {menuClass}
      {confirmDeletionModalId}
      {isScrollPositionRestored}
    />
  </ItemsContainer>
{/if}
