import { ServerStreamDTO } from './movie.dto';

export interface MovieEntity {
  id: string;
  name: string;
  slug: string;
  originalName: string;
  thumbUrl: string;
  posterUrl: string;
  description: string;
  totalEpisodes: number;
  currentEpisode: string;
  quality: string;
  language: string;
  director: string;
  casts: string;
  duration: string;
  year: string;
  categories: Array<{ id: string; name: string; slug: string }>;
  countries: Array<{ id: string; name: string; slug: string }>;
  servers: ServerStreamDTO[];
}
