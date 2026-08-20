import React from 'react';
import Link from 'next/link';

export default function NotFound() {
  return (
    <div className="min-h-screen bg-cinema-950 flex flex-col items-center justify-center p-6 text-center space-y-4">
      <h1 className="text-6xl font-black text-cinema-accent font-mono">404</h1>
      <h2 className="text-xl font-bold text-white">Trang Không Tồn Tại</h2>
      <p className="text-xs text-slate-400 max-w-sm">
        Đường dẫn bạn truy cập không tồn tại hoặc đã bị xóa khỏi hệ sinh thái phim.
      </p>
      <Link
        href="/"
        className="bg-cyan-500 hover:bg-cyan-400 text-black font-black text-xs px-6 py-3 rounded-xl transition"
      >
        ← Quay Lại Trang Chủ
      </Link>
    </div>
  );
}
