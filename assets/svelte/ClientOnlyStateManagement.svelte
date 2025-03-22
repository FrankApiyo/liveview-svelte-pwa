<script lang="ts" context="module">
  export function getParsedValueFromLocalStorage<T>(
    key: string,
    expectedType: string,
    defaultValue: T,
  ): T {
    const jsonString = localStorage.getItem(key);

    return getParsedValueFromJsonString(jsonString, expectedType, defaultValue);
  }

  export function getParsedValueFromSessionStorage<T>(
    key: string,
    expectedType: string,
    defaultValue: T,
  ): T {
    const jsonString = sessionStorage.getItem(key);

    return getParsedValueFromJsonString(jsonString, expectedType, defaultValue);
  }

  function getParsedValueFromJsonString<T>(
    jsonString: string | null,
    expectedType: string,
    defaultValue: T,
  ): T {
    if (!jsonString) return defaultValue;

    try {
      const parsedValue = JSON.parse(jsonString);
      return typeof parsedValue === expectedType ? parsedValue : defaultValue;
    } catch {
      return defaultValue;
    }
  }
</script>

<script lang="ts">
  import { onMount } from "svelte";

  import {
    isJournalsOpened,
    isJournalOpened,
    itemToProcessId,
    newJournal,
    newJournal,
    openedMenuId,
  } from "$stores/clientOnlyState";

  export let isClientStateRestored: boolean;

  onMount(() => {
    // Sync client state stores with sessionStorage on startup. This is mainly
    // to restore UI if the browser unexpectedly refreshes.
    $isJournalsOpened = getParsedValueFromSessionStorage(
      "isJournalsOpened",
      "boolean",
      $isJournalsOpened,
    );
    $isJournalOpened = getParsedValueFromSessionStorage(
      "isJournalOpened",
      "boolean",
      $isJournalOpened,
    );
    $itemToProcessId = getParsedValueFromSessionStorage(
      "itemToProcessId",
      "string",
      $itemToProcessId,
    );
    $newJournal = getParsedValueFromSessionStorage("newJournal", "string", $newJournal);
    $newJournal = getParsedValueFromSessionStorage("newJournal", "string", $newJournal);
    $openedMenuId = getParsedValueFromSessionStorage("openedMenuId", "string", $openedMenuId);

    // Let offline-svelte know that the client state has been restored in order
    // to restore scroll position.
    isClientStateRestored = true;
  });

  // Keep sessionStorage in sync with client state stores.
  $: if (isClientStateRestored) {
    sessionStorage.setItem("isJournalsOpened", JSON.stringify($isJournalsOpened));
    sessionStorage.setItem("isJournalOpened", JSON.stringify($isJournalOpened));
    sessionStorage.setItem("itemToProcessId", JSON.stringify($itemToProcessId));
    sessionStorage.setItem("newJournal", JSON.stringify($newJournal));
    sessionStorage.setItem("newJournal", JSON.stringify($newJournal));
    sessionStorage.setItem("openedMenuId", JSON.stringify($openedMenuId));
  }
</script>
