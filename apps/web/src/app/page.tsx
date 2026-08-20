import React from 'react';
import { movieService } from '../core/services/MovieService';
import { HeroBanner } from '../components/common/HeroBanner';
import { MovieCard } from '../components/common/MovieCard';
import { Header } from '../components/common/Header';

export const revalidate = 300; // Revalidate mỗi 5 phút

export default async function HomePage() {
  let movies = [];
  try {
    const data = await movieService.getRecentMovies(1);
    movies = data.items;
  } catch (error) {
    console.error('Error fetching home movies:', error);
  }

  const heroMovie = movies[0];
  const listMovies = movies.slice(1);

  return (
    <div className="min-h-screen bg-cinema-950 text-slate-100 flex flex-col">
      <Header />
      <main className="flex-1">
        {heroMovie && <HeroBanner movie={heroMovie} />}

        <section className="px-6 md:px-16 py-10 space-y-4">
          <div className="flex items-center justify-between">
            <h3 className="text-xl font-black text-white uppercase flex items-center gap-2">
              <span className="w-1.5 h-5 bg-cinema-accent rounded-full inline-block" />
              Phim Mới Cập Nhật (API phim.nguonc.com)
            </h3>
          </div>

          <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-6 gap-5">
            {listMovies.map((movie) => (
              <MovieCard key={movie.slug} movie={movie} />
            ))}
          </div>
        </section>
      </main>
    </div>
  );
}
