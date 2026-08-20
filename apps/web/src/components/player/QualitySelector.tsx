'use client';

import React from 'react';
import { ServerStreamDTO } from '../../types/movie.dto';

interface QualitySelectorProps {
  servers: ServerStreamDTO[];
  currentServerIndex: number;
  onSelectServer: (index: number) => void;
}

export const QualitySelector: React.FC<QualitySelectorProps> = ({
  servers,
  currentServerIndex,
  onSelectServer,
}) => {
  if (!servers || servers.length <= 1) return null;

  return (
    <div className="flex items-center space-x-3 bg-cinema-900 p-3 rounded-2xl border border-slate-800">
      <span className="text-xs font-bold text-slate-400">Chọn Máy Chủ Máy Phát:</span>
      <div className="flex flex-wrap gap-2">
        {servers.map((srv, idx) => (
          <button
            key={srv.server_name}
            onClick={() => onSelectServer(idx)}
            className={`px-3 py-1.5 rounded-xl text-xs font-bold transition ${
              idx === currentServerIndex
                ? 'bg-cyan-400 text-black shadow-lg'
                : 'bg-slate-800 text-slate-300 hover:bg-slate-700'
            }`}
          >
            {srv.server_name}
          </button>
        ))}
      </div>
    </div>
  );
};
