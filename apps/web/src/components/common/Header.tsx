'use client';

import React, { useState } from 'react';
import Link from 'next/link';
import { useRouter } from 'next/navigation';

export const Header: React.FC = () => {
  const [keyword, setKeyword] = useState('');
  const router = useRouter();

  const handleSearch = (e: React.FormEvent) => {
    e.preventDefault();
    if (keyword.trim()) {
      router.push(`/search?keyword=${encodeURIComponent(keyword.trim())}`);
    }
  };

  return (
    <header className="bg-cinema-900/90 backdrop-blur border-b border-slate-800/80 px-6 py-3 flex items-center justify-between sticky top-0 z-40">
      <div className="flex items-center space-x-8">
        <Link href="/" className="text-2xl font-black tracking-tight text-transparent bg-clip-text bg-gradient-to-r from-cyan-400 via-amber-400 to-red-500">
          ChillPhim
        </Link>
        <nav className="hidden lg:flex items-center space-x-6 text-sm font-semibold text-slate-300">
          <Link href="/" className="hover:text-white transition">Trang Chủ</Link>
          <Link href="/danh-sach/phim-bo" className="hover:text-cyan-400 transition">Phim Bộ</Link>
          <Link href="/danh-sach/phim-le" className="hover:text-cyan-400 transition">Phim Lẻ</Link>
          <Link href="/danh-sach/hoat-hinh" className="hover:text-cyan-400 transition">Hoạt Hình</Link>
          <Link href="/library" className="hover:text-cyan-400 transition">Tủ Phim</Link>
        </nav>
      </div>

      <form onSubmit={handleSearch} className="relative w-64 md:w-80">
        <input
          type="text"
          value={keyword}
          onChange={(e) => setKeyword(e.target.value)}
          placeholder="Tìm kiếm phim, diễn viên..."
          className="w-full bg-slate-800/90 border border-slate-700 text-xs text-slate-200 rounded-full pl-9 pr-4 py-2 focus:outline-none focus:border-cyan-400 transition"
        />
        <span className="absolute left-3 top-2.5 text-slate-400 text-xs">🔍</span>
      </form>
    </header>
  );
};
