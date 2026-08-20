import React from 'react';
import Link from 'next/link';
import { movieService } from '../../../core/services/MovieService';
import { Header } from '../../../components/common/Header';

interface FilmDetailProps {
  params: { slug: string };
}

export default async function FilmDetailPage({ params }: FilmDetailProps) {
  let movie;
  try {
    movie = await movieService.getMovieDetail(params.slug);
  } catch (error) {
    return (
      <div className="min-h-screen bg-cinema-950 text-slate-100 flex flex-col">
        <Header />
        <main className="flex-1 flex flex-col items-center justify-center p-8 text-center space-y-4">
          <h2 className="text-2xl font-bold text-red-500">Không Tìm Thấy Phim</h2>
          <p className="text-slate-400 text-sm">Phim bạn yêu cầu không tồn tại hoặc đã bị gỡ bỏ.</p>
          <Link href="/" className="bg-cyan-500 text-black font-bold px-6 py-2.5 rounded-xl">
            ← Quay Lại Trang Chủ
          </Link>
        </main>
      </div>
    );
  }

  const defaultServer = movie.servers && movie.servers.length > 0 ? movie.servers[0] : null;
  const episodeList = defaultServer && defaultServer.items ? defaultServer.items : [];

  const categoriesStr = Array.isArray(movie.categories) && movie.categories.length > 0
    ? movie.categories.map((c) => c.name).join(', ')
    : 'Cổ Trang, Thần Thoại';

  const countriesStr = Array.isArray(movie.countries) && movie.countries.length > 0
    ? movie.countries.map((c) => c.name).join(', ')
    : 'Trung Quốc';

  return (
    <div className="min-h-screen bg-cinema-950 text-slate-100 flex flex-col">
      <Header />
      <main className="flex-1 px-6 md:px-16 py-8 space-y-8">
        <div className="bg-cinema-800 border border-slate-700/80 rounded-3xl p-6 md:p-8 flex flex-col md:flex-row gap-8 shadow-2xl">
          {/* Poster */}
          <div className="w-52 md:w-64 flex-shrink-0 aspect-[2/3] rounded-2xl overflow-hidden shadow-2xl relative border border-slate-700">
            <img src={movie.posterUrl || movie.thumbUrl} alt={movie.name} className="w-full h-full object-cover" />
            <span className="absolute top-3 left-3 bg-cinema-accent text-white text-xs font-extrabold px-2.5 py-1 rounded shadow">
              {movie.quality || 'HD'}
            </span>
          </div>

          {/* Film Metadata (Contains all 7 required fields) */}
          <div className="space-y-5 flex-1">
            <div className="space-y-1">
              <h1 className="text-3xl md:text-4xl font-black text-white">{movie.name}</h1>
              <p className="text-slate-400 text-sm italic">{movie.originalName}</p>
            </div>

            {/* 7 Required Metadata Fields */}
            <div className="grid grid-cols-2 md:grid-cols-4 gap-3 bg-slate-900/90 p-4 rounded-2xl border border-cyan-500/30 text-xs">
              <div className="space-y-0.5">
                <span className="text-slate-400 block text-[11px]">1. Số Tập:</span>
                <span className="text-cyan-400 font-bold text-sm">{movie.totalEpisodes} Tập</span>
              </div>
              <div className="space-y-0.5">
                <span className="text-slate-400 block text-[11px]">2. Thời Lượng:</span>
                <span className="text-slate-100 font-semibold">{movie.duration}</span>
              </div>
              <div className="space-y-0.5">
                <span className="text-slate-400 block text-[11px]">3. Đạo Diễn:</span>
                <span className="text-slate-100 font-semibold">{movie.director}</span>
              </div>
              <div className="space-y-0.5">
                <span className="text-slate-400 block text-[11px]">4. Năm Phát Hành:</span>
                <span className="text-cyan-400 font-bold">{movie.year}</span>
              </div>
              <div className="space-y-0.5">
                <span className="text-slate-400 block text-[11px]">5. Thể Loại:</span>
                <span className="text-cyan-300 font-semibold">{categoriesStr}</span>
              </div>
              <div className="space-y-0.5">
                <span className="text-slate-400 block text-[11px]">6. Quốc Gia:</span>
                <span className="text-slate-100 font-semibold">{countriesStr}</span>
              </div>
              <div className="col-span-2 space-y-0.5">
                <span className="text-slate-400 block text-[11px]">7. Diễn Viên:</span>
                <span className="text-slate-200 font-medium">{movie.casts}</span>
              </div>
            </div>

            <p className="text-slate-300 text-sm leading-relaxed">{movie.description}</p>

            <div className="flex items-center space-x-4 pt-2">
              <Link
                href={`/watch/${movie.slug}?ep=${episodeList[0] ? episodeList[0].name : '01'}`}
                className="bg-cinema-accent hover:bg-red-700 text-white font-bold px-6 py-3 rounded-xl shadow-lg flex items-center space-x-2"
              >
                <span>▶ Xem Ngay (Tập {episodeList[0] ? episodeList[0].name : '1'})</span>
              </Link>
            </div>
          </div>
        </div>

        {/* Episode Selector Grid */}
        <div className="bg-cinema-800 border border-slate-800 rounded-2xl p-6 space-y-4">
          <div className="flex items-center justify-between">
            <h3 className="text-base font-bold text-white">Danh Sách Tập Phim:</h3>
            {defaultServer && (
              <span className="bg-cyan-500/20 text-cyan-400 px-3 py-1 rounded text-xs font-bold border border-cyan-500/30">
                Server: {defaultServer.server_name}
              </span>
            )}
          </div>

          <div className="flex flex-wrap gap-2.5">
            {episodeList.map((ep, idx) => (
              <Link
                key={ep.slug || idx}
                href={`/watch/${movie.slug}?ep=${ep.name}`}
                className={`w-12 h-10 ${
                  idx === 0 ? 'bg-cinema-accent text-white font-bold' : 'bg-slate-800 hover:bg-slate-700 text-slate-200'
                } text-xs rounded-xl flex items-center justify-center transition`}
              >
                {ep.name}
              </Link>
            ))}
          </div>
        </div>
      </main>
    </div>
  );
}
