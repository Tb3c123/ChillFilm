import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import '../../../data/models/movie_model.dart';

class TvVideoPlayerScreen extends StatefulWidget {
  final MovieModel movie;
  final EpisodeModel episode;

  const TvVideoPlayerScreen({
    Key? key,
    required this.movie,
    required this.episode,
  }) : super(key: key);

  @override
  State<TvVideoPlayerScreen> createState() => _TvVideoPlayerScreenState();
}

class _TvVideoPlayerScreenState extends State<TvVideoPlayerScreen> {
  VideoPlayerController? _controller;
  bool _isPlaying = true;
  bool _showControls = true;

  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  void _initPlayer() async {
    if (widget.episode.m3u8.isNotEmpty) {
      _controller = VideoPlayerController.networkUrl(Uri.parse(widget.episode.m3u8));
      await _controller!.initialize();
      _controller!.play();
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _handleKeyEvent(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.select ||
          event.logicalKey == LogicalKeyboardKey.enter ||
          event.logicalKey == LogicalKeyboardKey.space) {
        // Nút OK: Play / Pause
        setState(() {
          if (_controller != null && _controller!.value.isPlaying) {
            _controller!.pause();
            _isPlaying = false;
          } else {
            _controller?.play();
            _isPlaying = true;
          }
        });
      } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        // Tua lùi 10s
        if (_controller != null) {
          final current = _controller!.value.position;
          _controller!.seekTo(current - const Duration(seconds: 10));
        }
      } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        // Tua tới 10s
        if (_controller != null) {
          final current = _controller!.value.position;
          _controller!.seekTo(current + const Duration(seconds: 10));
        }
      } else if (event.logicalKey == LogicalKeyboardKey.goBack ||
          event.logicalKey == LogicalKeyboardKey.escape) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: FocusNode()..requestFocus(),
      onKey: _handleKeyEvent,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            // Video Canvas
            Positioned.fill(
              child: _controller != null && _controller!.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: _controller!.value.aspectRatio,
                      child: VideoPlayer(_controller!),
                    )
                  : const Center(
                      child: CircularProgressIndicator(color: Color(0xFF00E5FF)),
                    ),
            ),

            // Top HUD Title Bar
            Positioned(
              top: 32,
              left: 32,
              right: 32,
              child: AnimatedOpacity(
                opacity: _showControls ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${widget.movie.name} - ${widget.episode.name}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00E5FF).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFF00E5FF)),
                      ),
                      child: const Text(
                        '1080p60 HLS',
                        style: TextStyle(
                          color: Color(0xFF00E5FF),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Remote Guide
            Positioned(
              bottom: 32,
              left: 32,
              right: 32,
              child: AnimatedOpacity(
                opacity: _showControls ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0C1018).withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          Icon(
                            _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                            color: const Color(0xFF00E5FF),
                            size: 28,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'OK: Play/Pause',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const Row(
                        children: [
                          Icon(Icons.replay_10_rounded, color: Colors.white70),
                          SizedBox(width: 8),
                          Text('Trái/Phải: Tua 10s', style: TextStyle(color: Colors.white70)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
