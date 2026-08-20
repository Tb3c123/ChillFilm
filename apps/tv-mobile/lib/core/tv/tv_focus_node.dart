import 'package:flutter/widgets.dart';

class TvFocusNodeHelper {
  static FocusNode createTvNode({String? debugLabel}) {
    return FocusNode(
      debugLabel: debugLabel ?? 'TvFocusNode',
      skipTraversal: false,
      canRequestFocus: true,
    );
  }
}
