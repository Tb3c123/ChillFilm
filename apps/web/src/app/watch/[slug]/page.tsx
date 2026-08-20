import React from 'react';
import Link from 'next/link';
import { movieService } from '../../../core/services/MovieService';
import { VideoPlayer } from '../../../components/player/VideoPlayer';
import { Header } from '../../../components/common/Header';

interface WatchPageProps {
  params: { slug: string };
  searchParams: { ep?: string; server?: string };
}

export default async function WatchPage({ params, searchParams }: WatchPageProps) {
  const movie = await movieService.getMovieDetail(params.slug);

  const serverIndex = searchParams.server ? parseInt(searchParams.server, 10) : 0;
  const currentServer = movie.servers[serverIndex] || movie.servers[0];
  const episodeList = currentServer ? currentServer.items : [];

  const epName = searchParams.ep || (episodeList[0] ? episodeList[0].name : '01');
  const currentEp = episodeList.find((e) => e.name === epName) || episodeList[0];

  return (
    <div className="min-h-screen bg-cinema-950 text-slate-100 flex flex-col">
      <Header />

      <main className="flex-1 px-4 md:px-16 py-6 space-y-6 max-w-7xl mx-auto w-full">
        {/* Title */}
        <div className="flex flex-wrap items-center justify-between gap-4 border-b border-slate-800 pb-4">
          <div>
            <h1 className="text-xl md:text-2xl font-black text-white flex items-center gap-2">
              <span className="text-cinema-accent">●</span> {movie.name} - Tập {epName}
            </h1>
            <p className="text-xs text-slate-400">{movie.originalName}</p>
          </div>

          <Link
            href={`/film/${movie.slug}`}
            className="bg-slate-800 hover:bg-slate-700 text-slate-300 text-xs font-semibold px-4 py-2 rounded-xl border border-slate-700"
          >
            ← Chi Tiết Phim
          </Link>
        </div>

        {/* Video Player */}
        {currentEp ? (
          <VideoPlayer
            m3u8Url={currentEp.m3u8}
            embedUrl={currentEp.embed}
            title={`${movie.name} - Tập ${epName}`}
            slug={movie.slug}
            episodeName={epName}
            poster={movie.posterUrl || movie.thumbUrl}
          />
        ) : (
          <div className="p-12 text-center text-slate-400 bg-slate-900 rounded-2xl">
            Không tìm thấy tập phim yêu cầu.
          </div>
        )}

        {/* Server Switcher */}
        {movie.servers.length > 1 && (
          <div className="flex items-center space-x-3 bg-cinema-900 p-3 rounded-xl border border-slate-800">
            <span className="text-xs font-bold text-slate-400">Đổi Server:</span>
            {movie.servers.map((srv, idx) => (
              <Link
                key={srv.server_name}
                href={`/watch/${movie.slug}?ep=${epName}&server=${idx}`}
                className={`px-3 py-1 rounded-lg text-xs font-semibold ${
                  idx === serverIndex ? 'bg-cyan-500 text-black font-bold' : 'bg-slate-800 text-slate-300'
                }`}
              >
                {srv.server_name}
              </Link>
            ))}
          </div>
        )}

        {/* Episode Picker */}
        <div className="bg-cinema-800 border border-slate-800 rounded-2xl p-6 space-y-4">
          <h3 className="text-sm font-bold text-white">Chọn Tập Phim:</h3>
          <div className="flex flex-wrap gap-2.5">
            {episodeList.map((ep) => (
              <Link
                key={ep.slug}
                href={`/watch/${movie.slug}?ep=${ep.name}&server=${serverIndex}`}
                className={`w-12 h-10 ${
                  ep.name === epName
                    ? 'bg-cinema-accent text-white font-bold shadow-lg ring-2 ring-red-500'
                    : 'bg-slate-800 hover:bg-slate-700 text-slate-300'
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
