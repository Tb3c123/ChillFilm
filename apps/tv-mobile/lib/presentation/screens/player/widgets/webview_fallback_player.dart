import 'package:flutter/material.dart';

class WebviewFallbackPlayer extends StatelessWidget {
  final String embedUrl;

  const WebviewFallbackPlayer({Key? key, required this.embedUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Center(
        child: Text(
          'Đang mở link nhúng embed web: $embedUrl',
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
