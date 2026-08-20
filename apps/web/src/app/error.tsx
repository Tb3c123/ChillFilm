'use client';

import React, { useEffect } from 'react';

export default function ErrorPage({
  error,
  reset,
}: {
  error: Error & { digest?: string };
  reset: () => void;
}) {
  useEffect(() => {
    console.error('App Route Error:', error);
  }, [error]);

  return (
    <div className="min-h-screen bg-cinema-950 flex flex-col items-center justify-center p-6 text-center">
      <div className="max-w-md bg-cinema-900 border border-red-500/30 rounded-3xl p-8 space-y-4">
        <h2 className="text-2xl font-black text-white">Xảy Ra Sự Cố</h2>
        <p className="text-xs text-slate-400">
          {error.message || 'Không thể kết nối hoặc tải dữ liệu từ phim.nguonc.com.'}
        </p>
        <button
          onClick={() => reset()}
          className="bg-cinema-accent hover:bg-red-700 text-white text-xs font-bold px-6 py-3 rounded-xl transition"
        >
          Thử Lại Trực Tiếp
        </button>
      </div>
    </div>
  );
}
