'use client';

import React, { useState, useEffect } from 'react';
import { useSearchParams } from 'next/navigation';
import { movieService } from '../../core/services/MovieService';
import { MovieEntity } from '../../types/movie.entity';
import { Header } from '../../components/common/Header';
import { SearchBar } from '../../components/search/SearchBar';
import { FilterModal } from '../../components/search/FilterModal';
import { MovieCard } from '../../components/common/MovieCard';
import { SkeletonCard } from '../../components/common/SkeletonCard';
import { Pagination } from '../../components/common/Pagination';

export default function SearchPage() {
  const searchParams = useSearchParams();
  const initialKeyword = searchParams.get('keyword') || '';

  const [keyword, setKeyword] = useState(initialKeyword);
  const [category, setCategory] = useState('');
  const [genre, setGenre] = useState('');
  const [country, setCountry] = useState('');
  const [movies, setMovies] = useState<MovieEntity[]>([]);
  const [loading, setLoading] = useState(false);
  const [page, setPage] = useState(1);
  const [totalPages, setTotalPages] = useState(1);

  useEffect(() => {
    let isMounted = true;
    async function fetchSearch() {
      setLoading(true);
      try {
        if (keyword.trim()) {
          const res = await movieService.searchMovies(keyword, page);
          if (isMounted) {
            setMovies(res.items);
            if (res.paginate) setTotalPages(res.paginate.total_page || 1);
          }
        } else {
          const res = await movieService.getRecentMovies(page);
          if (isMounted) {
            setMovies(res.items);
            if (res.paginate) setTotalPages(res.paginate.total_page || 1);
          }
        }
      } catch (err) {
        console.error('Search error:', err);
      } finally {
        if (isMounted) setLoading(false);
      }
    }

    fetchSearch();
    return () => { isMounted = false; };
  }, [keyword, page]);

  return (
    <div className="min-h-screen bg-cinema-950 text-slate-100 flex flex-col">
      <Header />
      <main className="flex-1 px-6 md:px-16 py-8 space-y-6">
        <div className="space-y-4">
          <h1 className="text-2xl font-black text-white flex items-center gap-2">
            <span className="text-cyan-400">🔍</span> Tìm Kiếm Phim Nâng Cao
          </h1>

          <SearchBar onSearch={(q) => { setKeyword(q); setPage(1); }} />

          <FilterModal
            category={category}
            genre={genre}
            country={country}
            onSelectCategory={setCategory}
            onSelectGenre={setGenre}
            onSelectCountry={setCountry}
          />
        </div>

        <div className="space-y-4">
          <p className="text-xs text-slate-400">
            {keyword ? `Kết quả tìm kiếm cho từ khóa: "${keyword}"` : 'Tất cả phim mới cập nhật'}
          </p>

          {loading ? (
            <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-6 gap-5">
              {Array.from({ length: 12 }).map((_, i) => (
                <SkeletonCard key={i} />
              ))}
            </div>
          ) : movies.length > 0 ? (
            <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-6 gap-5">
              {movies.map((movie) => (
                <MovieCard key={movie.slug} movie={movie} />
              ))}
            </div>
          ) : (
            <div className="p-12 text-center text-slate-400 bg-cinema-900 rounded-3xl border border-slate-800">
              Không tìm thấy phim phù hợp với từ khóa của bạn.
            </div>
          )}

          <Pagination
            currentPage={page}
            totalPages={totalPages}
            onPageChange={(p) => setPage(p)}
          />
        </div>
      </main>
    </div>
  );
}
