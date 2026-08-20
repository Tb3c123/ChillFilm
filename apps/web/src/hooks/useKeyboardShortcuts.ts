import { useEffect } from 'react';

interface KeyboardShortcutsCallbacks {
  onTogglePlay?: () => void;
  onSeekForward?: () => void;
  onSeekBackward?: () => void;
  onToggleFullscreen?: () => void;
  onToggleMute?: () => void;
}

export function useKeyboardShortcuts(callbacks: KeyboardShortcutsCallbacks) {
  useEffect(() => {
    const handleKeyDown = (e: KeyboardEvent) => {
      // Không bắt phím khi đang nhập ô tìm kiếm
      const target = e.target as HTMLElement;
      if (target.tagName === 'INPUT' || target.tagName === 'TEXTAREA') return;

      switch (e.code) {
        case 'Space':
        case 'KeyK':
          e.preventDefault();
          callbacks.onTogglePlay?.();
          break;
        case 'ArrowRight':
        case 'KeyL':
          e.preventDefault();
          callbacks.onSeekForward?.();
          break;
        case 'ArrowLeft':
        case 'KeyJ':
          e.preventDefault();
          callbacks.onSeekBackward?.();
          break;
        case 'KeyF':
          e.preventDefault();
          callbacks.onToggleFullscreen?.();
          break;
        case 'KeyM':
          e.preventDefault();
          callbacks.onToggleMute?.();
          break;
      }
    };

    window.addEventListener('keydown', handleKeyDown);
    return () => window.removeEventListener('keydown', handleKeyDown);
  }, [callbacks]);
}
