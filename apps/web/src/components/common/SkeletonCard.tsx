'use client';

import React from 'react';

export const SkeletonCard: React.FC = () => {
  return (
    <div className="rounded-2xl overflow-hidden bg-cinema-800 border border-slate-800 animate-pulse space-y-3 p-2">
      <div className="aspect-[2/3] bg-slate-800 rounded-xl w-full" />
      <div className="h-4 bg-slate-800 rounded w-3/4" />
      <div className="h-3 bg-slate-800/60 rounded w-1/2" />
    </div>
  );
};
