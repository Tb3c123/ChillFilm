'use client';

import React from 'react';

interface IframeEmbedProps {
  embedUrl: string;
  title: string;
}

export const IframeEmbed: React.FC<IframeEmbedProps> = ({ embedUrl, title }) => {
  return (
    <div className="relative w-full aspect-video bg-black rounded-2xl overflow-hidden border border-slate-800 shadow-2xl group">
      {/* Sandbox iframe ngăn cản hoàn toàn việc nhảy tab hay pop-up khi chạm/tua video */}
      <iframe
        src={embedUrl}
        title={title}
        className="w-full h-full border-0 pointer-events-auto relative z-10"
        allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; fullscreen"
        sandbox="allow-scripts allow-same-origin allow-forms"
        allowFullScreen
      />

      {/* Lớp phủ bảo vệ bổ sung chặn các phần tử clickjack động */}
      <style jsx global>{`
        iframe[src*="ads"], iframe[src*="bet"], [class*="ad-"], [id*="ad-"] {
          display: none !important;
          pointer-events: none !important;
        }
      `}</style>
    </div>
  );
};
