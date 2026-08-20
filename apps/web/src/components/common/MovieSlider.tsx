'use client';

import React, { useRef } from 'react';
import { MovieEntity } from '../../types/movie.entity';
import { MovieCard } from './MovieCard';

interface MovieSliderProps {
  title: string;
  movies: MovieEntity[];
}

export const MovieSlider: React.FC<MovieSliderProps> = ({ title, movies }) => {
  const scrollRef = useRef<HTMLDivElement>(null);

  const scroll = (direction: 'left' | 'right') => {
    if (scrollRef.current) {
      const { scrollLeft, clientWidth } = scrollRef.current;
      const scrollAmount = clientWidth * 0.75;
      scrollRef.current.scrollTo({
        left: direction === 'left' ? scrollLeft - scrollAmount : scrollLeft + scrollAmount,
        behavior: 'smooth',
      });
    }
  };

  return (
    <section className="space-y-4 relative">
      <div className="flex items-center justify-between">
        <h3 className="text-xl font-black text-white uppercase flex items-center gap-2">
          <span className="w-2 h-5 bg-cyan-400 rounded-full inline-block" />
          {title}
        </h3>
        <div className="flex space-x-2">
          <button
            onClick={() => scroll('left')}
            className="bg-slate-800 hover:bg-slate-700 text-white w-8 h-8 rounded-full flex items-center justify-center border border-slate-700 transition"
          >
            ‹
          </button>
          <button
            onClick={() => scroll('right')}
            className="bg-slate-800 hover:bg-slate-700 text-white w-8 h-8 rounded-full flex items-center justify-center border border-slate-700 transition"
          >
            ›
          </button>
        </div>
      </div>

      <div
        ref={scrollRef}
        className="flex space-x-5 overflow-x-auto no-scrollbar scroll-smooth pb-4"
      >
        {movies.map((movie) => (
          <div key={movie.slug} className="w-44 sm:w-52 flex-shrink-0">
            <MovieCard movie={movie} />
          </div>
        ))}
      </div>
    </section>
  );
};
