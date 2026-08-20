import React from 'react';

export default function Loading() {
  return (
    <div className="min-h-screen bg-cinema-950 flex flex-col items-center justify-center space-y-4">
      <div className="w-12 h-12 border-4 border-cinema-accent border-t-transparent rounded-full animate-spin" />
      <p className="text-xs text-slate-400 font-mono tracking-wider">ĐANG TẢI DỮ LIỆU PHIM...</p>
    </div>
  );
}
