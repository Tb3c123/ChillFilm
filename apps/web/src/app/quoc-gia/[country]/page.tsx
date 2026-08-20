import React from 'react';
import { movieService } from '../../../core/services/MovieService';
import { Header } from '../../../components/common/Header';
import { MovieCard } from '../../../components/common/MovieCard';

interface CountryPageProps {
  params: { country: string };
  searchParams: { page?: string };
}

export default async function CountryPage({ params, searchParams }: CountryPageProps) {
  const page = searchParams.page ? parseInt(searchParams.page, 10) : 1;
  const data = await movieService.getMoviesByCountry(params.country, page);

  return (
    <div className="min-h-screen bg-cinema-950 text-slate-100 flex flex-col">
      <Header />
      <main className="flex-1 px-6 md:px-16 py-8 space-y-6">
        <h1 className="text-2xl font-black text-white uppercase flex items-center gap-2">
          <span className="w-2 h-6 bg-amber-400 rounded-full inline-block" /> Phim Quốc Gia: {params.country}
        </h1>

        <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-6 gap-5">
          {data.items.map((movie) => (
            <MovieCard key={movie.slug} movie={movie} />
          ))}
        </div>
      </main>
    </div>
  );
}
