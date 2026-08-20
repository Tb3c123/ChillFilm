export interface EpisodeEntity {
  name: string;
  slug: string;
  embedUrl: string;
  m3u8Url: string;
  serverName: string;
}

export interface ServerStreamEntity {
  serverName: string;
  episodes: EpisodeEntity[];
}
