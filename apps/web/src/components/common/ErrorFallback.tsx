'use client';

import React from 'react';

interface ErrorFallbackProps {
  message?: string;
  onRetry?: () => void;
}

export const ErrorFallback: React.FC<ErrorFallbackProps> = ({ message, onRetry }) => {
  return (
    <div className="p-8 bg-cinema-900 border border-red-500/30 rounded-3xl text-center space-y-4 max-w-lg mx-auto">
      <div className="w-12 h-12 bg-red-600/20 text-cinema-accent rounded-full flex items-center justify-center mx-auto font-black text-2xl">
        !
      </div>
      <h3 className="text-base font-bold text-white">Không Thể Tải Dữ Liệu</h3>
      <p className="text-xs text-slate-400">
        {message || 'Đã xảy ra sự cố kết nối tới máy chủ API phim.nguonc.com. Kiểm tra lại đường truyền của bạn.'}
      </p>
      {onRetry && (
        <button
          onClick={onRetry}
          className="bg-cinema-accent hover:bg-red-700 text-white font-bold text-xs px-6 py-2.5 rounded-xl shadow transition"
        >
          Thử Lại Trực Tiếp
        </button>
      )}
    </div>
  );
};
