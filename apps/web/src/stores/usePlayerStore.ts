import { create } from 'zustand';

interface PlayerState {
  currentServerIndex: number;
  currentEpisodeName: string;
  currentTime: number;
  duration: number;
  autoNext: boolean;
  playbackRate: number;
  isMuted: boolean;
  setServerIndex: (index: number) => void;
  setEpisodeName: (name: string) => void;
  setTimeline: (currentTime: number, duration: number) => void;
  toggleAutoNext: () => void;
  setPlaybackRate: (rate: number) => void;
  toggleMute: () => void;
}

export const usePlayerStore = create<PlayerState>((set) => ({
  currentServerIndex: 0,
  currentEpisodeName: '01',
  currentTime: 0,
  duration: 0,
  autoNext: true,
  playbackRate: 1.0,
  isMuted: false,
  setServerIndex: (index) => set({ currentServerIndex: index }),
  setEpisodeName: (name) => set({ currentEpisodeName: name }),
  setTimeline: (currentTime, duration) => set({ currentTime, duration }),
  toggleAutoNext: () => set((state) => ({ autoNext: !state.autoNext })),
  setPlaybackRate: (rate) => set({ playbackRate: rate }),
  toggleMute: () => set((state) => ({ isMuted: !state.isMuted })),
}));
