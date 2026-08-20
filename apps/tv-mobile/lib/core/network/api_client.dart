import 'package:dio/dio.dart';
import 'api_endpoints.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  late final Dio dio;

  factory ApiClient() => _instance;

  ApiClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (DioException error, handler) async {
          // Retry Logic khi timeout hoặc 5xx
          if (error.type == DioExceptionType.connectionTimeout ||
              error.type == DioExceptionType.receiveTimeout ||
              (error.response != null && error.response!.statusCode! >= 500)) {
            final requestOptions = error.requestOptions;
            try {
              final response = await dio.fetch(requestOptions);
              return handler.resolve(response);
            } catch (e) {
              return handler.next(error);
            }
          }
          return handler.next(error);
        },
      ),
    );
  }
}
