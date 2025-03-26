import { writable } from "svelte/store";

import type { Array as YArray, Map as YMap, Text as YText } from "yjs";

export interface Journal {
  id: string;
  body: YText; // Use Y.Text instead of string
  name: string;
  newName?: string;
  newBody?: string;
  isEditing?: boolean;
}

// Define the reactive Svelte store for journals
export const journals = writable<Journal[]>();

// Define Y.js shared data structure
export const yJournals = writable<YArray<YMap<string | boolean | YText>>>(); // Body is now YText
