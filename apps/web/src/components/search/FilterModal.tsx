'use client';

import React from 'react';
import { MOVIE_CATEGORIES, MOVIE_GENRES, MOVIE_COUNTRIES } from '../../utils/constants';

interface FilterModalProps {
  category: string;
  genre: string;
  country: string;
  onSelectCategory: (val: string) => void;
  onSelectGenre: (val: string) => void;
  onSelectCountry: (val: string) => void;
}

export const FilterModal: React.FC<FilterModalProps> = ({
  category,
  genre,
  country,
  onSelectCategory,
  onSelectGenre,
  onSelectCountry,
}) => {
  return (
    <div className="bg-cinema-900 border border-slate-800 p-5 rounded-3xl space-y-4">
      <h4 className="text-sm font-bold text-white uppercase tracking-wider flex items-center gap-2">
        <span className="w-1.5 h-4 bg-cinema-accent rounded-full inline-block" /> Bộ Lọc Phim Đa Năng
      </h4>

      <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
        {/* Category */}
        <div className="space-y-1">
          <label className="text-xs text-slate-400">Định Dạng:</label>
          <select
            value={category}
            onChange={(e) => onSelectCategory(e.target.value)}
            className="w-full bg-slate-800 border border-slate-700 text-xs text-slate-200 rounded-xl p-2.5 focus:outline-none focus:border-cyan-400"
          >
            <option value="">Tất cả định dạng</option>
            {MOVIE_CATEGORIES.map((c) => (
              <option key={c.slug} value={c.slug}>{c.name}</option>
            ))}
          </select>
        </div>

        {/* Genre */}
        <div className="space-y-1">
          <label className="text-xs text-slate-400">Thể Loại:</label>
          <select
            value={genre}
            onChange={(e) => onSelectGenre(e.target.value)}
            className="w-full bg-slate-800 border border-slate-700 text-xs text-slate-200 rounded-xl p-2.5 focus:outline-none focus:border-cyan-400"
          >
            <option value="">Tất cả thể loại</option>
            {MOVIE_GENRES.map((g) => (
              <option key={g.slug} value={g.slug}>{g.name}</option>
            ))}
          </select>
        </div>

        {/* Country */}
        <div className="space-y-1">
          <label className="text-xs text-slate-400">Quốc Gia:</label>
          <select
            value={country}
            onChange={(e) => onSelectCountry(e.target.value)}
            className="w-full bg-slate-800 border border-slate-700 text-xs text-slate-200 rounded-xl p-2.5 focus:outline-none focus:border-cyan-400"
          >
            <option value="">Tất cả quốc gia</option>
            {MOVIE_COUNTRIES.map((ct) => (
              <option key={ct.slug} value={ct.slug}>{ct.name}</option>
            ))}
          </select>
        </div>
      </div>
    </div>
  );
};
