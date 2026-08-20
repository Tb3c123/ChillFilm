import 'package:flutter/services.dart';

enum DPadAction { up, down, left, right, select, back }

class DPadDetector {
  static DPadAction? detectAction(KeyEvent event) {
    if (event is! KeyDownEvent) return null;

    final key = event.logicalKey;
    if (key == LogicalKeyboardKey.arrowUp) return DPadAction.up;
    if (key == LogicalKeyboardKey.arrowDown) return DPadAction.down;
    if (key == LogicalKeyboardKey.arrowLeft) return DPadAction.left;
    if (key == LogicalKeyboardKey.arrowRight) return DPadAction.right;
    if (key == LogicalKeyboardKey.select || key == LogicalKeyboardKey.enter) return DPadAction.select;
    if (key == LogicalKeyboardKey.goBack || key == LogicalKeyboardKey.escape) return DPadAction.back;

    return null;
  }
}
