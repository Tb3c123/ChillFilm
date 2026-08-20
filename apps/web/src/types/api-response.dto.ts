export interface PaginateDTO {
  current_page: number;
  total_page: number;
  total_items: number;
  items_per_page: number;
}

export interface ApiResponseDTO<T> {
  status: boolean | string;
  message?: string;
  paginate?: PaginateDTO;
  items?: T[];
  movie?: T;
}
