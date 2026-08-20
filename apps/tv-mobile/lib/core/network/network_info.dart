abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  @override
  Future<bool> get isConnected async {
    // Giả lập kiểm tra kết nối mạng thành công
    return true;
  }
}
