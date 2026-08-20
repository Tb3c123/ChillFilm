import 'package:flutter/material.dart';

class WebviewFallbackPlayer extends StatelessWidget {
  final String embedUrl;

  const WebviewFallbackPlayer({Key? key, required this.embedUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF121722),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFF00E5FF).withOpacity(0.5)),
              ),
              child: const Icon(Icons.play_circle_fill_rounded, color: Color(0xFF00E5FF), size: 64),
            ),
            const SizedBox(height: 20),
            const Text(
              'Đang phát qua Trình Nhúng Máy Chủ Embed Web',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              embedUrl,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white54, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}
