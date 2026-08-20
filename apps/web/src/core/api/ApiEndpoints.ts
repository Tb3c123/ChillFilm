export const API_BASE_URL = 'https://phim.nguonc.com/api';

export const API_ENDPOINTS = {
  RECENT_MOVIES: (page: number = 1) => `/films/phim-moi-cap-nhat?page=${page}`,
  FILM_DETAIL: (slug: string) => `/film/${slug}`,
  GENRE_MOVIES: (slug: string, page: number = 1) => `/films/the-loai/${slug}?page=${page}`,
  COUNTRY_MOVIES: (slug: string, page: number = 1) => `/films/quoc-gia/${slug}?page=${page}`,
  CATEGORY_MOVIES: (slug: string, page: number = 1) => `/films/danh-sach/${slug}?page=${page}`,
  SEARCH_MOVIES: (keyword: string, page: number = 1) => `/films/search?keyword=${encodeURIComponent(keyword)}&page=${page}`,
};
