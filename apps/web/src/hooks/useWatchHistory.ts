import { useEffect } from 'react';
import { storageService, WatchHistoryItem } from '../core/services/StorageService';

export function useWatchHistory(item?: WatchHistoryItem) {
  useEffect(() => {
    if (!item) return;

    const interval = setInterval(() => {
      if (item.currentTime > 5 && item.duration > 0) {
        storageService.saveWatchHistory(item);
      }
    }, 5000); // Tự động lưu tiến trình mỗi 5s

    return () => clearInterval(interval);
  }, [item]);

  return {
    history: storageService.getWatchHistory(),
  };
}
