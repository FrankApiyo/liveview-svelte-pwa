import { writable } from "svelte/store";

export const isJournalsOpened = writable<boolean>(true);
export const isJournalOpened = writable<boolean>(true);
export const itemToProcessId = writable<string>("");
export const newJournal = writable<string>("");
export const openedMenuId = writable<string>("");

export const selectedJournalId = writable<string>("");
export const urlHash = writable<"" | "about" | "journalId">("");
