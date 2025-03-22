import { writable } from "svelte/store";

export const isListsOpened = writable<boolean>(true);
export const isJournalOpened = writable<boolean>(true);
export const itemToProcessId = writable<string>("");
export const newList = writable<string>("");
export const newJournal = writable<string>("");
export const openedMenuId = writable<string>("");

export const selectedListId = writable<string>("");
export const urlHash = writable<"" | "about" | "listId">("");
