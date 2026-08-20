class LocalStorage {
  static final LocalStorage _instance = LocalStorage._internal();
  final Map<String, dynamic> _memoryStorage = {};

  factory LocalStorage() => _instance;

  LocalStorage._internal();

  Future<void> init() async {
    // Khởi tạo storage đơn giản
  }

  void setString(String key, String value) {
    _memoryStorage[key] = value;
  }

  String? getString(String key) {
    return _memoryStorage[key] as String?;
  }

  void saveWatchHistory(String slug, String episodeName, int positionSeconds) {
    _memoryStorage['history_$slug'] = {
      'episode': episodeName,
      'position': positionSeconds,
      'updatedAt': DateTime.now().toIso8601String(),
    };
  }

  Map<String, dynamic>? getWatchHistory(String slug) {
    return _memoryStorage['history_$slug'] as Map<String, dynamic>?;
  }
}
