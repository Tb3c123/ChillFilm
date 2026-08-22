import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';

enum DeviceType { tv, tablet, mobile }

class DeviceUtil {
  static bool? _isTvDeviceCache;
  static bool _isInitializing = false;

  /// Khởi tạo kiểm tra cờ phần cứng TV hệ thống qua device_info_plus
  static Future<void> init() async {
    if (_isTvDeviceCache != null || _isInitializing) return;
    _isInitializing = true;
    try {
      if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
        final androidInfo = await DeviceInfoPlugin().androidInfo;
        final systemFeatures = androidInfo.systemFeatures;
        final isLeanback = systemFeatures.contains('android.software.leanback');
        final hasTouch = systemFeatures.contains('android.hardware.touchscreen');
        _isTvDeviceCache = isLeanback || !hasTouch;
      } else {
        _isTvDeviceCache = false;
      }
    } catch (_) {
      _isTvDeviceCache = false;
    }
    _isInitializing = false;
  }

  /// Phân loại TV: Chỉ true nếu là thiết bị Android TV không màn hình cảm ứng hoặc ở cờ TV
  static bool isTv(BuildContext context) {
    if (_isTvDeviceCache != null) return _isTvDeviceCache!;
    final navigationMode = MediaQuery.of(context).navigationMode;
    return navigationMode == NavigationMode.directional;
  }

  /// Tablet: Thiết bị màn hình lớn (width >= 600) NHƯNG hỗ trợ Cảm ứng Touch-first
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return !isTv(context) && width >= 600;
  }

  /// Mobile: Điện thoại màn hình tiêu chuẩn (width < 600)
  static bool isMobile(BuildContext context) {
    return !isTv(context) && !isTablet(context);
  }

  static DeviceType getDeviceType(BuildContext context) {
    if (isTv(context)) return DeviceType.tv;
    if (isTablet(context)) return DeviceType.tablet;
    return DeviceType.mobile;
  }
}
