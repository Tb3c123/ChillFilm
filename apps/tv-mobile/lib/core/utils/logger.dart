import 'package:flutter/foundation.dart';

class Logger {
  static void d(String message) {
    if (kDebugMode) {
      print('[DEBUG] [${DateTime.now()}] $message');
    }
  }

  static void e(String message, [dynamic error]) {
    print('[ERROR] [${DateTime.now()}] $message ${error ?? ''}');
  }
}
