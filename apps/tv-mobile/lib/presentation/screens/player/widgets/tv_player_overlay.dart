import 'package:flutter/material.dart';

class TvPlayerOverlay extends StatelessWidget {
  final String title;
  final String episodeName;
  final bool isPlaying;

  const TvPlayerOverlay({
    Key? key,
    required this.title,
    required this.episodeName,
    required this.isPlaying,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black45,
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('$title - $episodeName', style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          Icon(isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled, color: const Color(0xFF00E5FF), size: 36),
        ],
      ),
    );
  }
}
