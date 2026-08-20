class ServerException implements Exception {
  final String message;
  ServerException([this.message = 'Lỗi kết nối máy chủ']);
}

class CacheException implements Exception {
  final String message;
  CacheException([this.message = 'Lỗi truy xuất bộ nhớ tạm']);
}

class NetworkException implements Exception {
  final String message;
  NetworkException([this.message = 'Mất kết nối Internet']);
}
