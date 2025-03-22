import { writable } from "svelte/store";

import type { Array as YArray, Map as YMap } from "yjs";

export interface TodoList {
  id: string;
  body: string;
  name: string;
  newName?: string;
  newBody?: string;
  isEditing?: boolean;
}

export interface TodoItem {
  id: string;
  name: string;
  completed: boolean;
  listId: string;
  newName?: string;
  isEditing?: boolean;
}

export const todoLists = writable<TodoList[]>();

export const yJournals = writable<YArray<YMap<string | boolean>>>();
