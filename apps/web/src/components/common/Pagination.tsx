'use client';

import React from 'react';

interface PaginationProps {
  currentPage: number;
  totalPages: number;
  onPageChange: (page: number) => void;
}

export const Pagination: React.FC<PaginationProps> = ({
  currentPage,
  totalPages,
  onPageChange,
}) => {
  if (totalPages <= 1) return null;

  return (
    <div className="flex items-center justify-center space-x-2 pt-8">
      <button
        disabled={currentPage <= 1}
        onClick={() => onPageChange(currentPage - 1)}
        className="px-4 py-2 bg-slate-800 hover:bg-slate-700 disabled:opacity-40 rounded-xl text-xs font-bold text-white transition"
      >
        Trang Trước
      </button>

      <span className="text-xs text-slate-300 px-4 font-mono">
        Trang <strong className="text-cyan-400">{currentPage}</strong> / {totalPages}
      </span>

      <button
        disabled={currentPage >= totalPages}
        onClick={() => onPageChange(currentPage + 1)}
        className="px-4 py-2 bg-slate-800 hover:bg-slate-700 disabled:opacity-40 rounded-xl text-xs font-bold text-white transition"
      >
        Trang Sau
      </button>
    </div>
  );
};
