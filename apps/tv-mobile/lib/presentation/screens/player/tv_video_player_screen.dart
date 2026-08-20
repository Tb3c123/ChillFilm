import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import '../../../data/models/movie_model.dart';
import 'widgets/webview_fallback_player.dart';

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
  bool _useEmbedFallback = false;

  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  void _initPlayer() async {
    final m3u8Url = widget.episode.m3u8;

    // Nếu m3u8 rỗng, chuyển ngay sang WebView Embed Player
    if (m3u8Url.isEmpty) {
      if (mounted) setState(() { _useEmbedFallback = true; });
      return;
    }

    try {
      _controller = VideoPlayerController.networkUrl(
        Uri.parse(m3u8Url),
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
      );

      // Timeout sau 1.5s nếu luồng Native m3u8 không phản hồi ➔ Chuyển sang WebView Embed
      await _controller!.initialize().timeout(const Duration(milliseconds: 1500), onTimeout: () {
        throw TimeoutException('Luồng Native m3u8 phản hồi chậm');
      });

      _controller!.play();
      if (mounted) {
        setState(() {
          _isPlaying = true;
          _useEmbedFallback = false;
        });
      }
    } catch (e) {
      // Khi gặp sự cố hoặc timeout ➔ Tự động kích hoạt WebView Embed Player
      if (mounted) {
        setState(() {
          _useEmbedFallback = true;
        });
      }
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
        // Nút OK: Play / Pause (trên Native Player)
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
        if (_controller != null && _controller!.value.isInitialized) {
          final current = _controller!.value.position;
          _controller!.seekTo(current - const Duration(seconds: 10));
        }
      } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        // Tua tới 10s
        if (_controller != null && _controller!.value.isInitialized) {
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
            // Video Canvas hoac Hybrid WebView Embed Player
            Positioned.fill(
              child: _useEmbedFallback
                  ? WebviewFallbackPlayer(embedUrl: widget.episode.embed)
                  : _controller != null && _controller!.value.isInitialized
                      ? AspectRatio(
                          aspectRatio: _controller!.value.aspectRatio,
                          child: VideoPlayer(_controller!),
                        )
                      : const Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator(color: Color(0xFF00E5FF)),
                              SizedBox(height: 16),
                              Text(
                                'Đang nạp trình phát video...',
                                style: TextStyle(color: Colors.white70, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
            ),

            // Top HUD Title Bar
            Positioned(
              top: 24,
              left: 24,
              right: 24,
              child: AnimatedOpacity(
                opacity: _showControls ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${widget.movie.name} - Tập ${widget.episode.name}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00E5FF).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFF00E5FF)),
                      ),
                      child: Text(
                        _useEmbedFallback ? 'WEB EMBED PLAYER' : '1080p HLS AUTO',
                        style: const TextStyle(
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
          ],
        ),
      ),
    );
  }
}
