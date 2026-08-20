export const buildFilmUrl = (slug: string): string => {
  return `/film/${encodeURIComponent(slug)}`;
};

export const buildWatchUrl = (slug: string, episodeName: string = '01', serverIndex: number = 0): string => {
  return `/watch/${encodeURIComponent(slug)}?ep=${encodeURIComponent(episodeName)}&server=${serverIndex}`;
};

export const isHlsUrl = (url: string): boolean => {
  return typeof url === 'string' && url.includes('.m3u8');
};
