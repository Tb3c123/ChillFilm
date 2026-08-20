import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/storage/local_storage.dart';
import 'core/utils/logger.dart';
import 'app.dart';

void main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Khởi tạo Local Storage
    await LocalStorage().init();

    // Khóa hướng màn hình ngang cho TV / Cinema
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitUp,
    ]);

    // Ẩn thanh trạng thái hệ thống cho trải nghiệm Cinema
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    runApp(const WatchFilmApp());
  }, (error, stack) {
    Logger.e('Unhandled Flutter Exception caught in Zone:', error);
  });
}
