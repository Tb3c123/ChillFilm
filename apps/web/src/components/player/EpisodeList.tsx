'use client';

import React from 'react';
import Link from 'next/link';
import { EpisodeItemDTO } from '../../types/movie.dto';

interface EpisodeListProps {
  slug: string;
  episodes: EpisodeItemDTO[];
  currentEpName: string;
  serverIndex: number;
}

export const EpisodeList: React.FC<EpisodeListProps> = ({
  slug,
  episodes,
  currentEpName,
  serverIndex,
}) => {
  return (
    <div className="bg-cinema-800 border border-slate-800 rounded-3xl p-6 space-y-4">
      <h3 className="text-sm font-bold text-white">Danh Sách Tập Phim:</h3>
      <div className="flex flex-wrap gap-2.5 max-h-60 overflow-y-auto no-scrollbar">
        {episodes.map((ep) => {
          const isActive = ep.name === currentEpName;
          return (
            <Link
              key={ep.slug}
              href={`/watch/${slug}?ep=${encodeURIComponent(ep.name)}&server=${serverIndex}`}
              className={`w-12 h-10 ${
                isActive
                  ? 'bg-cinema-accent text-white font-black shadow-lg ring-2 ring-red-500'
                  : 'bg-slate-800 hover:bg-slate-700 text-slate-300 font-semibold'
              } text-xs rounded-xl flex items-center justify-center transition`}
            >
              {ep.name}
            </Link>
          );
        })}
      </div>
    </div>
  );
};
