import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure([String message = 'Lỗi máy chủ phim.nguonc.com']) : super(message);
}

class NetworkFailure extends Failure {
  const NetworkFailure([String message = 'Không có kết nối mạng']) : super(message);
}

class CacheFailure extends Failure {
  const CacheFailure([String message = 'Lỗi bộ nhớ tạm']) : super(message);
}
