import { writable } from "svelte/store";

import type { Array as YArray, Map as YMap } from "yjs";

export interface Journal {
  id: string;
  body: string;
  name: string;
  newName?: string;
  newBody?: string;
  isEditing?: boolean;
}

export const journals = writable<Journal[]>();

export const yJournals = writable<YArray<YMap<string | boolean>>>();
