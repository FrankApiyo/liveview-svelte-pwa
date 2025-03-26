<script lang="ts" context="module">
  export type DeleteItem = (item: Journal) => void;

  export type DndHandler = (event: CustomEvent, updateUi: (newItems: Journal[]) => void) => void;

  export type UpdateItem = (newItem: Journal) => void;
</script>

<script lang="ts">
  import { SOURCES, TRIGGERS } from "svelte-dnd-action";
  import * as Y from "yjs";

  import {
    isJournalsOpened,
    isJournalOpened,
    itemToProcessId,
    newJournal,
    newJournal,
    openedMenuId,
    selectedJournalId,
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

  // Journal journal handlers ___________________________________________________________________________
  function addJournal() {
    const journal = new Y.Map<string>();
    journal.set("id", crypto.randomUUID());
    journal.set("name", $newJournal);
    $yJournals.unshift([journal]);

    $newJournal = "";

    syncDocumentToServer($liveView);
  }

  function updateJournal() {
    return;
  }

  const updateItem: UpdateItem = (newItem) => {
    for (const yJournal of $yJournals) {
      if (yJournal.get("id") === newItem.id) {
        if (!yJournal.has("body")) {
          yJournal.set("body", new Y.Text()); // Initialize if missing
        }
        const yBody = yJournal.get("body") as Y.Text;

        $yJournals.doc.transact(() => {
          // Handle name updates
          yJournal.set("name", newItem.name);

          if (newItem.newName === undefined || newItem.newName === "") {
            yJournal.delete("newName");
          } else {
            yJournal.set("name", newItem.newName);
          }

          // Handle body updates
          if (newItem.newBody !== undefined) {
            // Calculate difference between old and new text
            const currentText = yBody.toString();
            const oldText = newItem.body;
            const newText = newItem.newBody;

            // Apply changes as delta operations
            // This diffing algorithm can be turned off by a setting
            applyTextChanges(yBody, oldText, newText);
          } else {
            yJournal.delete("newBody");
          }

          // Handle editing state
          if (newItem.isEditing === undefined) {
            yJournal.delete("isEditing");
          } else {
            yJournal.set("isEditing", newItem.isEditing);
          }
        });

        syncDocumentToServer($liveView);
        return;
      }
    }
  };

  // Helper function to apply text changes as deltas
  function applyTextChanges(yText: Y.Text, oldText: string, newText: string) {
    // If texts are identical, no changes needed
    if (oldText === newText) return;

    // If the Y.Text is empty or completely different, just set the new value
    if (yText.length === 0 || yText.toString() !== oldText) {
      yText.delete(0, yText.length);
      yText.insert(0, newText);
      return;
    }

    // Find the first difference between old and new text
    let i = 0;
    while (i < oldText.length && i < newText.length && oldText[i] === newText[i]) {
      i++;
    }

    // Find the last difference between old and new text
    let j = oldText.length - 1;
    let k = newText.length - 1;
    while (j >= i && k >= i && oldText[j] === newText[k]) {
      j--;
      k--;
    }

    // Apply the changes
    if (j < i) {
      // Only insertions
      yText.insert(i, newText.substring(i, k + 1));
    } else if (k < i) {
      // Only deletions
      yText.delete(i, j - i + 1);
    } else {
      // Replacements
      yText.delete(i, j - i + 1);
      yText.insert(i, newText.substring(i, k + 1));
    }
  }

  const deleteItem: DeleteItem = (item) => {
    var index = 0;
    for (const yJournal of $yJournals) {
      if (yJournal.get("id") === item.id) {
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
    // Update the items journal in the UI.
    const newItems = filterDuplicates(event.detail.items);
    updateUiOnConsider(newItems);

    // Ensure dragging is stopped on drag finish via keyboard.
    const { source, trigger } = event.detail.info;
    if (source === SOURCES.KEYBOARD && trigger === TRIGGERS.DRAG_STOPPED) {
      dragDisabled = true;
    }
  };

  const handleFinalize: DndHandler = (event, updateUiOnFinalize) => {
    // Update the items journal in the UI.
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

  // Keep selected journal name and items in sync with selected journal id _______________________________

  function setSelectedJournalName(journalId: string) {
    return $journals.find((journal) => journal.id === journalId)?.name ?? "";
  }
  $: selectedJournalName = setSelectedJournalName($selectedJournalId);
  $: selectedJournal = $journals.find((item) => item.id === $selectedJournalId);
</script>

{#if $itemToProcessId && $openedMenuId === confirmDeletionModalId}
  <ConfirmDeletionModal journalId={$itemToProcessId} {menuClass} {deleteItem} />
{/if}

{#if $selectedJournalId}
  <ItemsContainer
    title={selectedJournalName}
    bind:isDropdownOpened={$isJournalOpened}
    {isScrollPositionRestored}
  >
    <JournalEditor item={selectedJournal} {updateItem} {menuClass} />
  </ItemsContainer>
{:else}
  <NewItemForm
    addItemCallback={addJournal}
    bind:value={$newJournal}
    placeholder="Enter journal title"
    submitButtonText="Create"
    submitButtonTitle="Create new journal."
    {isScrollPositionRestored}
  />

  <ItemsContainer
    title="Journals"
    bind:isDropdownOpened={$isJournalsOpened}
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
