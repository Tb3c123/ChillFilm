class ApiEndpoints {
  static const String baseUrl = 'https://phim.nguonc.com/api';
  
  static String recentMovies(int page) => '/films/phim-moi-cap-nhat?page=$page';
  static String filmDetail(String slug) => '/film/$slug';
  static String searchMovies(String keyword, int page) => '/films/search?keyword=${Uri.encodeComponent(keyword)}&page=$page';
}
