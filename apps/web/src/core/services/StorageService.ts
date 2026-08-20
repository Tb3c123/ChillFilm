export interface WatchHistoryItem {
  slug: string;
  title: string;
  poster: string;
  episodeSlug: string;
  episodeName: string;
  currentTime: number;
  duration: number;
  updatedAt: string;
}

export class StorageService {
  private static instance: StorageService;
  private readonly HISTORY_KEY = 'nguonc_watch_history';
  private readonly BOOKMARK_KEY = 'nguonc_bookmarks';

  private constructor() {}

  public static getInstance(): StorageService {
    if (!StorageService.instance) {
      StorageService.instance = new StorageService();
    }
    return StorageService.instance;
  }

  // Quản lý Watch History (Xem tiếp)
  public saveWatchHistory(item: WatchHistoryItem): void {
    if (typeof window === 'undefined') return;
    try {
      const history = this.getWatchHistory();
      const filtered = history.filter((h) => h.slug !== item.slug);
      filtered.unshift({ ...item, updatedAt: new Date().toISOString() });
      localStorage.setItem(this.HISTORY_KEY, JSON.stringify(filtered.slice(0, 50)));
    } catch (e) {
      console.error('[StorageService] Error saving watch history:', e);
    }
  }

  public getWatchHistory(): WatchHistoryItem[] {
    if (typeof window === 'undefined') return [];
    try {
      const data = localStorage.getItem(this.HISTORY_KEY);
      return data ? JSON.parse(data) : [];
    } catch {
      return [];
    }
  }

  // Quản lý Bookmarks (Tủ phim yêu thích)
  public getBookmarks(): string[] {
    if (typeof window === 'undefined') return [];
    try {
      const data = localStorage.getItem(this.BOOKMARK_KEY);
      return data ? JSON.parse(data) : [];
    } catch {
      return [];
    }
  }

  public toggleBookmark(slug: string): boolean {
    if (typeof window === 'undefined') return false;
    try {
      const bookmarks = this.getBookmarks();
      const index = bookmarks.indexOf(slug);
      let isBookmarked = false;
      if (index >= 0) {
        bookmarks.splice(index, 1);
        isBookmarked = false;
      } else {
        bookmarks.push(slug);
        isBookmarked = true;
      }
      localStorage.setItem(this.BOOKMARK_KEY, JSON.stringify(bookmarks));
      return isBookmarked;
    } catch {
      return false;
    }
  }
}

export const storageService = StorageService.getInstance();
