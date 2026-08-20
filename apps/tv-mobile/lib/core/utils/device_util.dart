import 'package:flutter/widgets.dart';

class DeviceUtil {
  static bool isTv(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= 900;
  }
}
