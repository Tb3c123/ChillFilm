'use client';

import React from 'react';
import { formatDuration } from '../../utils/formatters';

interface PlayerControlsProps {
  isPlaying: boolean;
  currentTime: number;
  duration: number;
  playbackRate: number;
  isMuted: boolean;
  onTogglePlay: () => void;
  onSeek: (seconds: number) => void;
  onChangeRate: (rate: number) => void;
  onToggleMute: () => void;
  onToggleFullscreen: () => void;
}

export const PlayerControls: React.FC<PlayerControlsProps> = ({
  isPlaying,
  currentTime,
  duration,
  playbackRate,
  isMuted,
  onTogglePlay,
  onSeek,
  onChangeRate,
  onToggleMute,
  onToggleFullscreen,
}) => {
  return (
    <div className="bg-cinema-900/95 border border-slate-800 p-4 rounded-2xl flex flex-col space-y-3">
      {/* Seekbar */}
      <div className="flex items-center space-x-3 text-xs text-slate-300">
        <span>{formatDuration(currentTime)}</span>
        <input
          type="range"
          min={0}
          max={duration || 100}
          value={currentTime}
          onChange={(e) => onSeek(parseFloat(e.target.value))}
          className="flex-1 accent-cyan-400 cursor-pointer h-1.5 bg-slate-800 rounded-lg"
        />
        <span>{formatDuration(duration)}</span>
      </div>

      {/* Control Buttons */}
      <div className="flex items-center justify-between">
        <div className="flex items-center space-x-3">
          <button
            onClick={onTogglePlay}
            className="bg-cinema-accent hover:bg-red-700 text-white w-10 h-10 rounded-xl flex items-center justify-center font-bold shadow"
          >
            {isPlaying ? '❚❚' : '▶'}
          </button>

          <button
            onClick={onToggleMute}
            className="bg-slate-800 text-slate-200 px-3 py-2 rounded-xl text-xs font-semibold"
          >
            {isMuted ? '🔇 Tắt Tiếng' : '🔊 Âm Thanh'}
          </button>

          <select
            value={playbackRate}
            onChange={(e) => onChangeRate(parseFloat(e.target.value))}
            className="bg-slate-800 border border-slate-700 text-xs text-slate-200 rounded-xl px-2 py-2 focus:outline-none"
          >
            <option value={0.75}>0.75x</option>
            <option value={1.0}>1.0x (Chuẩn)</option>
            <option value={1.25}>1.25x</option>
            <option value={1.5}>1.5x</option>
            <option value={2.0}>2.0x</option>
          </select>
        </div>

        <button
          onClick={onToggleFullscreen}
          className="bg-slate-800 hover:bg-slate-700 text-slate-200 px-4 py-2 rounded-xl text-xs font-bold"
        >
          ⛶ Toàn Màn Hình
        </button>
      </div>
    </div>
  );
};
