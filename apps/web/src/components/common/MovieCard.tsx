'use client';

import React from 'react';
import Link from 'next/link';
import { MovieEntity } from '../../types/movie.entity';

interface MovieCardProps {
  movie: MovieEntity;
}

export const MovieCard: React.FC<MovieCardProps> = ({ movie }) => {
  return (
    <Link href={`/film/${movie.slug}`} className="block group">
      <div className="relative rounded-2xl overflow-hidden bg-cinema-800 border border-slate-800 hover:border-cyan-400 transition-all duration-300 shadow-card-shadow hover:-translate-y-1.5">
        <div className="relative aspect-[2/3] overflow-hidden">
          <img
            src={movie.posterUrl || movie.thumbUrl}
            alt={movie.name}
            className="w-full h-full object-cover group-hover:scale-110 transition duration-500"
            loading="lazy"
          />
          {/* Quality Badge */}
          <span className="absolute top-2 left-2 bg-cinema-accent text-white text-[10px] font-extrabold px-2 py-0.5 rounded shadow">
            {movie.quality || 'HD'}
          </span>
          <div className="absolute inset-0 bg-gradient-to-t from-cinema-950 via-transparent to-transparent opacity-80" />
        </div>

        <div className="p-3 space-y-1">
          <h4 className="text-xs font-bold text-white group-hover:text-cyan-400 transition truncate">
            {movie.name}
          </h4>
          <p className="text-[11px] text-slate-400 truncate">
            {movie.year} • {movie.categories.map((c) => c.name).join(', ') || 'Cổ Trang'}
          </p>
        </div>
      </div>
    </Link>
  );
};
