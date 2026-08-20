'use client';

import React from 'react';

interface IframeEmbedProps {
  embedUrl: string;
  title: string;
}

export const IframeEmbed: React.FC<IframeEmbedProps> = ({ embedUrl, title }) => {
  return (
    <div className="relative w-full aspect-video bg-black rounded-2xl overflow-hidden border border-slate-800 shadow-2xl">
      <iframe
        src={embedUrl}
        title={title}
        className="w-full h-full border-0"
        allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; fullscreen"
        allowFullScreen
      />
    </div>
  );
};
