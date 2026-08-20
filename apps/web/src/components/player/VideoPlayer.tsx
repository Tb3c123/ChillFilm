'use client';

import React, { useEffect, useRef, useState } from 'react';
import Hls from 'hls.js';
import { IframeEmbed } from './IframeEmbed';
import { storageService } from '../../core/services/StorageService';

interface VideoPlayerProps {
  m3u8Url: string;
  embedUrl: string;
  title: string;
  slug: string;
  episodeName: string;
  poster: string;
}

export const VideoPlayer: React.FC<VideoPlayerProps> = ({
  m3u8Url,
  embedUrl,
  title,
  slug,
  episodeName,
  poster,
}) => {
  const videoRef = useRef<HTMLVideoElement>(null);
  const [useIframe, setUseIframe] = useState(false);
  const [resumeTime, setResumeTime] = useState<number | null>(null);

  useEffect(() => {
    // Phục hồi thời gian đã xem dở
    const history = storageService.getWatchHistory();
    const item = history.find((h) => h.slug === slug);
    if (item && item.currentTime > 5 && item.currentTime < item.duration - 10) {
      setResumeTime(item.currentTime);
    }
  }, [slug]);

  useEffect(() => {
    if (!m3u8Url || m3u8Url.trim() === '') {
      setUseIframe(true);
      return;
    }

    const video = videoRef.current;
    if (!video) return;

    let hls: Hls | null = null;

    if (Hls.isSupported()) {
      hls = new Hls({
        enableWorker: true,
        lowLatencyMode: true,
      });
      hls.loadSource(m3u8Url);
      hls.attachMedia(video);

      hls.on(Hls.Events.ERROR, (_, data) => {
        if (data.fatal) {
          console.warn('[VideoPlayer] Fatal HLS error encountered. Falling back to IframeEmbed...', data);
          setUseIframe(true);
        }
      });
    } else if (video.canPlayType('application/vnd.apple.mpegurl')) {
      // Hỗ trợ Safari native HLS
      video.src = m3u8Url;
    } else {
      setUseIframe(true);
    }

    return () => {
      if (hls) {
        hls.destroy();
      }
    };
  }, [m3u8Url]);

  // Tự động lưu tiến trình xem dở (currentTime) khi video đang phát
  const handleTimeUpdate = () => {
    const video = videoRef.current;
    if (!video || !video.duration) return;

    storageService.saveWatchHistory({
      slug,
      title,
      poster,
      episodeSlug: episodeName,
      episodeName,
      currentTime: Math.floor(video.currentTime),
      duration: Math.floor(video.duration),
      updatedAt: new Date().toISOString(),
    });
  };

  const handleLoadedMetadata = () => {
    const video = videoRef.current;
    if (video && resumeTime !== null) {
      video.currentTime = resumeTime;
    }
  };

  if (useIframe && embedUrl) {
    return <IframeEmbed embedUrl={embedUrl} title={title} />;
  }

  return (
    <div className="relative w-full aspect-video bg-black rounded-2xl overflow-hidden border border-slate-800 shadow-2xl">
      <video
        ref={videoRef}
        controls
        autoPlay
        playsInline
        onTimeUpdate={handleTimeUpdate}
        onLoadedMetadata={handleLoadedMetadata}
        poster={poster}
        className="w-full h-full object-contain"
      />
      {resumeTime !== null && (
        <div className="absolute top-4 right-4 bg-cinema-900/90 border border-cyan-500/50 text-cyan-400 text-xs px-3 py-1.5 rounded-xl shadow-lg">
          ⏱ Đã tiếp tục xem từ {Math.floor(resumeTime / 60)}m {Math.floor(resumeTime % 60)}s
        </div>
      )}
    </div>
  );
};
