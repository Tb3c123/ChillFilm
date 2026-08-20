export interface CategoryItemDTO {
  id: string;
  name: string;
  slug: string;
}

export interface CountryItemDTO {
  id: string;
  name: string;
  slug: string;
}

export interface EpisodeItemDTO {
  name: string;
  slug: string;
  embed: string;
  m3u8: string;
}

export interface ServerStreamDTO {
  server_name: string;
  items: EpisodeItemDTO[];
}

export interface MovieDTO {
  id: string;
  name: string;
  slug: string;
  original_name: string;
  thumb_url: string;
  poster_url: string;
  created: string;
  modified: string;
  description?: string;
  total_episodes?: number;
  current_episode?: string;
  quality?: string;
  language?: string;
  director?: string;
  casts?: string;
  time?: string;
  year?: number | string;
  category?: CategoryItemDTO[];
  country?: CountryItemDTO[];
  episodes?: ServerStreamDTO[];
}
