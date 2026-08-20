import { apiClient } from '../api/ApiClient';
import { API_ENDPOINTS } from '../api/ApiEndpoints';
import { MovieDTO } from '../../types/movie.dto';
import { MovieEntity } from '../../types/movie.entity';
import { ApiResponseDTO } from '../../types/api-response.dto';

export class MovieService {
  private static instance: MovieService;

  private constructor() {}

  public static getInstance(): MovieService {
    if (!MovieService.instance) {
      MovieService.instance = new MovieService();
    }
    return MovieService.instance;
  }

  // Parse category object/array safely
  private parseCategoriesAndCountries(rawCategory: any) {
    const categories: Array<{ id: string; name: string; slug: string }> = [];
    const countries: Array<{ id: string; name: string; slug: string }> = [];

    if (!rawCategory) return { categories, countries };

    if (Array.isArray(rawCategory)) {
      rawCategory.forEach((item: any) => {
        categories.push({
          id: item.id || '',
          name: item.name || '',
          slug: item.slug || '',
        });
      });
      return { categories, countries };
    }

    if (typeof rawCategory === 'object') {
      Object.values(rawCategory).forEach((groupObj: any) => {
        if (!groupObj || !groupObj.group || !groupObj.list) return;
        const groupName = groupObj.group.name || '';
        const listItems = groupObj.list || [];

        listItems.forEach((item: any) => {
          const catItem = {
            id: item.id || '',
            name: item.name || '',
            slug: item.slug || item.id || '',
          };

          if (groupName.includes('Quốc gia')) {
            countries.push(catItem);
          } else {
            categories.push(catItem);
          }
        });
      });
    }

    return { categories, countries };
  }

  // Transform MovieDTO -> MovieEntity
  private mapDtoToEntity(dto: MovieDTO): MovieEntity {
    const { categories, countries } = this.parseCategoriesAndCountries(dto.category);

    return {
      id: dto.id || '',
      name: dto.name || '',
      slug: dto.slug || '',
      originalName: dto.original_name || '',
      thumbUrl: dto.thumb_url || '',
      posterUrl: dto.poster_url || dto.thumb_url || '',
      description: dto.description || 'Đang cập nhật nội dung phim.',
      totalEpisodes: dto.total_episodes || 1,
      currentEpisode: dto.current_episode || 'HD',
      quality: dto.quality || 'HD',
      language: dto.language || 'Vietsub',
      director: dto.director || 'Đang cập nhật',
      casts: dto.casts || 'Đang cập nhật',
      duration: dto.time || '45 phút / tập',
      year: dto.year ? dto.year.toString() : '2026',
      categories: categories.length > 0 ? categories : [{ id: '1', name: 'Phim Hợp Cổ', slug: 'co-trang' }],
      countries: countries.length > 0 ? countries : [{ id: '1', name: 'Trung Quốc', slug: 'trung-quoc' }],
      servers: dto.episodes || [],
    };
  }

  // Lấy danh sách phim mới cập nhật
  public async getRecentMovies(page: number = 1): Promise<{ items: MovieEntity[]; paginate?: any }> {
    const res = await apiClient.get<ApiResponseDTO<MovieDTO>>(API_ENDPOINTS.RECENT_MOVIES(page));
    const items = (res.data.items || []).map((item) => this.mapDtoToEntity(item));
    return { items, paginate: res.data.paginate };
  }

  // Lấy chi tiết phim
  public async getMovieDetail(slug: string): Promise<MovieEntity> {
    const res = await apiClient.get<ApiResponseDTO<MovieDTO>>(API_ENDPOINTS.FILM_DETAIL(slug));
    if (!res.data || !res.data.movie) {
      throw new Error(`Không tìm thấy phim với slug: ${slug}`);
    }
    return this.mapDtoToEntity(res.data.movie);
  }

  // Tìm kiếm phim
  public async searchMovies(keyword: string, page: number = 1): Promise<{ items: MovieEntity[]; paginate?: any }> {
    const res = await apiClient.get<ApiResponseDTO<MovieDTO>>(API_ENDPOINTS.SEARCH_MOVIES(keyword, page));
    const items = (res.data.items || []).map((item) => this.mapDtoToEntity(item));
    return { items, paginate: res.data.paginate };
  }

  // Lấy danh sách phim theo Định dạng (Phim Lẻ, Phim Bộ, Hoạt Hình, TV Shows)
  public async getMoviesByCategory(categorySlug: string, page: number = 1): Promise<{ items: MovieEntity[]; paginate?: any }> {
    const res = await apiClient.get<ApiResponseDTO<MovieDTO>>(API_ENDPOINTS.CATEGORY_MOVIES(categorySlug, page));
    const items = (res.data.items || []).map((item) => this.mapDtoToEntity(item));
    return { items, paginate: res.data.paginate };
  }

  // Lấy danh sách phim theo Thể loại (Cổ Trang, Hành Động, Viễn Tưởng...)
  public async getMoviesByGenre(genreSlug: string, page: number = 1): Promise<{ items: MovieEntity[]; paginate?: any }> {
    const res = await apiClient.get<ApiResponseDTO<MovieDTO>>(API_ENDPOINTS.GENRE_MOVIES(genreSlug, page));
    const items = (res.data.items || []).map((item) => this.mapDtoToEntity(item));
    return { items, paginate: res.data.paginate };
  }

  // Lấy danh sách phim theo Quốc gia (Trung Quốc, Hàn Quốc, Mỹ...)
  public async getMoviesByCountry(countrySlug: string, page: number = 1): Promise<{ items: MovieEntity[]; paginate?: any }> {
    const res = await apiClient.get<ApiResponseDTO<MovieDTO>>(API_ENDPOINTS.COUNTRY_MOVIES(countrySlug, page));
    const items = (res.data.items || []).map((item) => this.mapDtoToEntity(item));
    return { items, paginate: res.data.paginate };
  }
}

export const movieService = MovieService.getInstance();
