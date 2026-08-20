'use client';

import React, { useEffect } from 'react';
import Link from 'next/link';
import { Header } from '../../components/common/Header';
import { useHistoryStore } from '../../stores/useHistoryStore';
import { useBookmarkStore } from '../../stores/useBookmarkStore';

export default function LibraryPage() {
  const { history, loadHistory, clearHistory } = useHistoryStore();
  const { bookmarks, loadBookmarks } = useBookmarkStore();

  useEffect(() => {
    loadHistory();
    loadBookmarks();
  }, [loadHistory, loadBookmarks]);

  return (
    <div className="min-h-screen bg-cinema-950 text-slate-100 flex flex-col">
      <Header />

      <main className="flex-1 px-6 md:px-16 py-8 space-y-10">
        {/* Continue Watching Section */}
        <section className="space-y-4">
          <div className="flex items-center justify-between">
            <h2 className="text-xl font-black text-white flex items-center gap-2">
              <span className="w-2 h-5 bg-cyan-400 rounded-full inline-block" /> Lịch Sử Xem Dở ({history.length})
            </h2>
            {history.length > 0 && (
              <button
                onClick={clearHistory}
                className="text-xs text-red-400 hover:text-red-300 font-semibold bg-slate-900 px-3 py-1.5 rounded-xl border border-slate-800"
              >
                🗑 Xóa Lịch Sử
              </button>
            )}
          </div>

          {history.length > 0 ? (
            <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4">
              {history.map((item) => (
                <div
                  key={item.slug}
                  className="bg-cinema-900 border border-slate-800 rounded-2xl p-4 flex gap-4 items-center"
                >
                  <img
                    src={item.poster}
                    alt={item.title}
                    className="w-16 h-24 object-cover rounded-xl border border-slate-700"
                  />
                  <div className="flex-1 space-y-1">
                    <h4 className="text-sm font-bold text-white line-clamp-1">{item.title}</h4>
                    <p className="text-xs text-cyan-400 font-semibold">Tập {item.episodeName}</p>
                    <p className="text-[11px] text-slate-400">
                      Đã xem: {Math.floor(item.currentTime / 60)}m / {Math.floor(item.duration / 60)}m
                    </p>
                    <Link
                      href={`/watch/${item.slug}?ep=${item.episodeName}`}
                      className="inline-block bg-cinema-accent hover:bg-red-700 text-white text-xs font-bold px-3 py-1 rounded-lg shadow mt-1"
                    >
                      ▶ Xem Tiếp
                    </Link>
                  </div>
                </div>
              ))}
            </div>
          ) : (
            <div className="p-8 text-center text-slate-400 bg-cinema-900 rounded-3xl border border-slate-800 text-xs">
              Bạn chưa có tiến trình xem dở nào.
            </div>
          )}
        </section>

        {/* Bookmarks Section */}
        <section className="space-y-4">
          <h2 className="text-xl font-black text-white flex items-center gap-2">
            <span className="w-2 h-5 bg-cinema-accent rounded-full inline-block" /> Tủ Phim Đã Lưu ({bookmarks.length})
          </h2>

          {bookmarks.length > 0 ? (
            <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-6 gap-4">
              {bookmarks.map((slug) => (
                <Link
                  key={slug}
                  href={`/film/${slug}`}
                  className="bg-cinema-900 border border-slate-800 rounded-2xl p-4 block hover:border-cyan-400 text-center"
                >
                  <p className="text-xs font-bold text-white truncate">{slug}</p>
                  <span className="text-[11px] text-cyan-400">Chi Tiết Phim →</span>
                </Link>
              ))}
            </div>
          ) : (
            <div className="p-8 text-center text-slate-400 bg-cinema-900 rounded-3xl border border-slate-800 text-xs">
              Chưa có phim nào trong tủ phim yêu thích.
            </div>
          )}
        </section>
      </main>
    </div>
  );
}
