import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../../data/models/movie_model.dart';
import 'widgets/webview_fallback_player.dart';

class MobileVideoPlayerScreen extends StatefulWidget {
  final MovieModel movie;
  final EpisodeModel episode;

  const MobileVideoPlayerScreen({
    super.key,
    required this.movie,
    required this.episode,
  });

  @override
  State<MobileVideoPlayerScreen> createState() => _MobileVideoPlayerScreenState();
}

class _MobileVideoPlayerScreenState extends State<MobileVideoPlayerScreen> {
  VideoPlayerController? _controller;
  bool _isPlaying = true;
  bool _useEmbedFallback = false;

  static const Map<String, String> _streamHeaders = {
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36',
    'Referer': 'https://phim.nguonc.com/',
    'Origin': 'https://phim.nguonc.com',
  };

  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  void _initPlayer() async {
    final m3u8Url = widget.episode.m3u8;

    if (m3u8Url.isEmpty) {
      if (mounted) setState(() { _useEmbedFallback = true; });
      return;
    }

    try {
      _controller = VideoPlayerController.networkUrl(
        Uri.parse(m3u8Url),
        httpHeaders: _streamHeaders,
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
      );

      // Tăng thời gian chờ thử nạp Native m3u8 lên 4s để tối đa hóa phát qua Player sạch
      await _controller!.initialize().timeout(const Duration(milliseconds: 4000), onTimeout: () {
        throw TimeoutException('Luồng Native m3u8 phản hồi chậm');
      });

      _controller!.play();
      if (mounted) {
        setState(() {
          _isPlaying = true;
          _useEmbedFallback = false;
        });
      }
    } catch (_) {
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

  void _togglePlayPause() {
    if (_controller == null || !_controller!.value.isInitialized) return;
    setState(() {
      if (_controller!.value.isPlaying) {
        _controller!.pause();
        _isPlaying = false;
      } else {
        _controller!.play();
        _isPlaying = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          '${widget.movie.name} - Tập ${widget.episode.name}',
          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: GestureDetector(
        onTap: _togglePlayPause,
        child: Center(
          child: _useEmbedFallback
              ? WebviewFallbackPlayer(embedUrl: widget.episode.embed)
              : _controller != null && _controller!.value.isInitialized
                  ? Stack(
                      alignment: Alignment.center,
                      children: [
                        AspectRatio(
                          aspectRatio: _controller!.value.aspectRatio,
                          child: VideoPlayer(_controller!),
                        ),
                        if (!_isPlaying)
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: const BoxDecoration(
                              color: Colors.black54,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.play_arrow_rounded, color: Color(0xFF00E5FF), size: 48),
                          ),
                      ],
                    )
                  : const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(color: Color(0xFF00E5FF)),
                        SizedBox(height: 16),
                        Text(
                          'Đang nạp trình phát video Native Sạch...',
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                      ],
                    ),
        ),
      ),
    );
  }
}
