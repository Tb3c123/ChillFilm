'use client';

import React, { useState } from 'react';
import { useDebounce } from '../../hooks/useDebounce';

interface SearchBarProps {
  onSearch: (query: string) => void;
}

export const SearchBar: React.FC<SearchBarProps> = ({ onSearch }) => {
  const [value, setValue] = useState('');
  const debouncedValue = useDebounce(value, 500);

  React.useEffect(() => {
    onSearch(debouncedValue);
  }, [debouncedValue, onSearch]);

  return (
    <div className="relative w-full max-w-xl">
      <input
        type="text"
        value={value}
        onChange={(e) => setValue(e.target.value)}
        placeholder="Nhập tên phim, diễn viên..."
        className="w-full bg-slate-800 border border-slate-700 text-sm text-white rounded-2xl pl-12 pr-4 py-3.5 focus:outline-none focus:border-cyan-400 shadow-xl transition"
      />
      <span className="absolute left-4 top-3.5 text-slate-400 text-base">🔍</span>
      {value && (
        <button
          onClick={() => setValue('')}
          className="absolute right-4 top-3 text-slate-400 hover:text-white text-xs bg-slate-700 rounded-full w-5 h-5 flex items-center justify-center"
        >
          ✕
        </button>
      )}
    </div>
  );
};
