import { create } from 'zustand';
import { storageService, WatchHistoryItem } from '../core/services/StorageService';

interface HistoryState {
  history: WatchHistoryItem[];
  loadHistory: () => void;
  clearHistory: () => void;
}

export const useHistoryStore = create<HistoryState>((set) => ({
  history: [],
  loadHistory: () => {
    const list = storageService.getWatchHistory();
    set({ history: list });
  },
  clearHistory: () => {
    if (typeof window !== 'undefined') {
      localStorage.removeItem('nguonc_watch_history');
    }
    set({ history: [] });
  },
}));
