'use client';

import React from 'react';
import Link from 'next/link';

export const Footer: React.FC = () => {
  return (
    <footer className="bg-cinema-900 border-t border-slate-800 text-slate-400 py-10 px-6 md:px-16 mt-16">
      <div className="max-w-7xl mx-auto grid grid-cols-1 md:grid-cols-4 gap-8">
        <div className="space-y-3">
          <span className="text-xl font-black tracking-tight text-transparent bg-clip-text bg-gradient-to-r from-cyan-400 via-amber-400 to-red-500">
            ChillPhim
          </span>
          <p className="text-xs leading-relaxed">
            ChillPhim - Trải nghiệm xem phim online chất lượng cao mượt mà trên mọi thiết bị Web, Mobile & Android TV.
          </p>
        </div>

        <div className="space-y-2 text-xs">
          <h4 className="font-bold text-white uppercase">Danh Mục Phim</h4>
          <ul className="space-y-1">
            <li><Link href="/danh-sach/phim-bo" className="hover:text-cyan-400">Phim Bộ Mới</Link></li>
            <li><Link href="/danh-sach/phim-le" className="hover:text-cyan-400">Phim Lẻ Chiếu Rạp</Link></li>
            <li><Link href="/danh-sach/hoat-hinh" className="hover:text-cyan-400">Hoạt Hình 3D</Link></li>
          </ul>
        </div>

        <div className="space-y-2 text-xs">
          <h4 className="font-bold text-white uppercase">Thể Loại</h4>
          <ul className="space-y-1">
            <li><Link href="/the-loai/co-trang" className="hover:text-cyan-400">Phim Cổ Trang</Link></li>
            <li><Link href="/the-loai/hanh-dong" className="hover:text-cyan-400">Phim Hành Động</Link></li>
            <li><Link href="/the-loai/vien-tuong" className="hover:text-cyan-400">Phim Viễn Tưởng</Link></li>
          </ul>
        </div>

        <div className="space-y-2 text-xs">
          <h4 className="font-bold text-white uppercase">Quyền Riêng Tư & Hỗ Trợ</h4>
          <p className="text-slate-500">Toàn bộ dữ liệu được nhúng trực tiếp từ các máy chủ truyền thông công cộng.</p>
        </div>
      </div>
      <div className="max-w-7xl mx-auto border-t border-slate-800/80 mt-8 pt-6 text-center text-[11px] text-slate-500">
        © 2026 ChillPhim. Built with Next.js 14 & Clean Architecture.
      </div>
    </footer>
  );
};
