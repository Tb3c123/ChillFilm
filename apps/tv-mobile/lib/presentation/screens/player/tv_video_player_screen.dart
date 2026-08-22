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
    super.key,
    required this.movie,
    required this.episode,
  });

  @override
  State<TvVideoPlayerScreen> createState() => _TvVideoPlayerScreenState();
}

class _TvVideoPlayerScreenState extends State<TvVideoPlayerScreen> {
  VideoPlayerController? _controller;
  bool _isPlaying = true;
  final bool _showControls = true;
  bool _useEmbedFallback = false;
  int _retryCount = 0;

  static const Map<String, String> _streamHeaders = {
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36',
    'Referer': 'https://phim.nguonc.com/',
    'Origin': 'https://phim.nguonc.com',
  };

  @override
  void initState() {
    super.initState();
    _initPlayerWithRetry();
  }

  void _initPlayerWithRetry() async {
    final m3u8Url = widget.episode.m3u8;

    if (m3u8Url.isEmpty) {
      if (mounted) setState(() { _useEmbedFallback = true; });
      return;
    }

    bool success = false;

    // Cơ chế Retry tối đa 3 lần cho Native Player trước khi mở WebView Embed
    while (_retryCount < 3 && !success && mounted) {
      try {
        _controller?.dispose();
        _controller = VideoPlayerController.networkUrl(
          Uri.parse(m3u8Url),
          httpHeaders: _streamHeaders,
          videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
        );

        // Lắng nghe lỗi segment khi tua để tự động nhảy cóc qua segment bị chặn/lỗi
        _controller!.addListener(_onControllerErrorCheck);

        await _controller!.initialize().timeout(const Duration(milliseconds: 3000), onTimeout: () {
          throw TimeoutException('Thử nạp Native m3u8 lần ${_retryCount + 1} quá thời gian');
        });

        _controller!.play();
        success = true;
        if (mounted) {
          setState(() {
            _isPlaying = true;
            _useEmbedFallback = false;
          });
        }
      } catch (_) {
        _retryCount++;
        await Future.delayed(const Duration(milliseconds: 500));
      }
    }

    if (!success && mounted) {
      setState(() {
        _useEmbedFallback = true;
      });
    }
  }

  void _onControllerErrorCheck() {
    if (_controller != null && _controller!.value.hasError) {
      // Khi gặp phân đoạn segment m3u8 bị lỗi hoặc chèn Ads lỗi ➔ Tự động tua tới 10s để vượt mốc lỗi
      final current = _controller!.value.position;
      _controller!.seekTo(current + const Duration(seconds: 10));
    }
  }

  @override
  void dispose() {
    _controller?.removeListener(_onControllerErrorCheck);
    _controller?.dispose();
    super.dispose();
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.select ||
          event.logicalKey == LogicalKeyboardKey.enter ||
          event.logicalKey == LogicalKeyboardKey.gameButtonA ||
          event.logicalKey == LogicalKeyboardKey.space) {
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
        if (_controller != null && _controller!.value.isInitialized) {
          final current = _controller!.value.position;
          _controller!.seekTo(current - const Duration(seconds: 10));
        }
      } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
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
    return KeyboardListener(
      focusNode: FocusNode()..requestFocus(),
      onKeyEvent: _handleKeyEvent,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
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
                                'Đang nạp trình phát Native HLS (Thử lại đến 3 lần)...',
                                style: TextStyle(color: Colors.white70, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
            ),

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
                        _useEmbedFallback ? 'WEB EMBED (ANTI-OVERLAY)' : '1080p HLS NATIVE (3x RETRY)',
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

            if (!_useEmbedFallback)
              Positioned(
                bottom: 24,
                left: 24,
                right: 24,
                child: AnimatedOpacity(
                  opacity: _showControls ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0C1018).withOpacity(0.9),
                      borderRadius: BorderRadius.circular(16),
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
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'OK: Play/Pause',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                          ],
                        ),
                        const Row(
                          children: [
                            Icon(Icons.replay_10_rounded, color: Colors.white70, size: 20),
                            SizedBox(width: 8),
                            Text('Trái/Phải: Tua 10s (Auto Skip Segment Ads)', style: TextStyle(color: Colors.white70, fontSize: 12)),
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
