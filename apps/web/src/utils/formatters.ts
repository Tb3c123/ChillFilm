export const formatDuration = (seconds: number): string => {
  if (!seconds || isNaN(seconds)) return '00:00';
  const mins = Math.floor(seconds / 60);
  const secs = Math.floor(seconds % 60);
  const formattedMins = mins < 10 ? `0${mins}` : `${mins}`;
  const formattedSecs = secs < 10 ? `0${secs}` : `${secs}`;
  return `${formattedMins}:${formattedSecs}`;
};

export const formatEpisodeNumber = (num: number | string): string => {
  const parsed = typeof num === 'number' ? num : parseInt(num, 10);
  if (isNaN(parsed)) return `${num}`;
  return parsed < 10 ? `0${parsed}` : `${parsed}`;
};

export const truncateText = (text: string, maxLength: number = 150): string => {
  if (!text || text.length <= maxLength) return text || '';
  return `${text.slice(0, maxLength)}...`;
};
