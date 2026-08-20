import { create } from 'zustand';
import { storageService } from '../core/services/StorageService';

interface BookmarkState {
  bookmarks: string[];
  loadBookmarks: () => void;
  toggleBookmark: (slug: string) => boolean;
  isBookmarked: (slug: string) => boolean;
}

export const useBookmarkStore = create<BookmarkState>((set, get) => ({
  bookmarks: [],
  loadBookmarks: () => {
    const list = storageService.getBookmarks();
    set({ bookmarks: list });
  },
  toggleBookmark: (slug) => {
    const isAdded = storageService.toggleBookmark(slug);
    const updated = storageService.getBookmarks();
    set({ bookmarks: updated });
    return isAdded;
  },
  isBookmarked: (slug) => {
    return get().bookmarks.includes(slug);
  },
}));
