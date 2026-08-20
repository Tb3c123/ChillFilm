'use client';

import React from 'react';
import Link from 'next/link';
import { MovieEntity } from '../../types/movie.entity';

interface HeroBannerProps {
  movie: MovieEntity;
}

export const HeroBanner: React.FC<HeroBannerProps> = ({ movie }) => {
  return (
    <section className="relative w-full h-[480px] md:h-[540px] overflow-hidden bg-slate-950">
      <img
        src={movie.posterUrl || movie.thumbUrl}
        alt={movie.name}
        className="w-full h-full object-cover opacity-40 filter blur-[1px]"
      />
      <div className="absolute inset-0 bg-gradient-to-t from-cinema-950 via-cinema-950/60 to-transparent" />
      <div className="absolute inset-0 bg-gradient-to-r from-cinema-950 via-cinema-950/80 to-transparent" />

      <div className="absolute bottom-12 left-6 md:left-16 max-w-2xl space-y-4">
        <div className="flex items-center space-x-3 text-xs font-semibold">
          <span className="bg-cinema-accent text-white px-2.5 py-0.5 rounded font-bold uppercase">Phim Nổi Bật</span>
          <span className="bg-cyan-500/20 text-cyan-400 px-2.5 py-0.5 rounded border border-cyan-500/30">
            {movie.quality || 'HD - Vietsub'}
          </span>
          <span className="text-amber-400 font-bold">★ 9.2</span>
          <span className="text-slate-300">{movie.year}</span>
        </div>

        <h2 className="text-3xl md:text-5xl font-black text-white leading-tight tracking-tight uppercase">
          {movie.name}
        </h2>
        <p className="text-slate-300 text-sm line-clamp-3 leading-relaxed">
          {movie.description || 'Bộ phim hấp dẫn không thể bỏ qua.'}
        </p>

        <div className="flex items-center space-x-4 pt-2">
          <Link
            href={`/watch/${movie.slug}?ep=1`}
            className="flex items-center space-x-2 bg-cinema-accent hover:bg-red-700 text-white font-bold px-6 py-3 rounded-xl shadow-lg transition transform hover:scale-105"
          >
            <span>▶ Xem Ngay Tập 1</span>
          </Link>
          <Link
            href={`/film/${movie.slug}`}
            className="flex items-center space-x-2 bg-slate-800/90 hover:bg-slate-700 text-slate-200 font-semibold px-5 py-3 rounded-xl border border-slate-700 backdrop-blur transition"
          >
            <span>ℹ Thông Tin Phim</span>
          </Link>
        </div>
      </div>
    </section>
  );
};
