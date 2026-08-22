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
  bool _showControls = true;
  Timer? _hideControlsTimer;

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

      await _controller!.initialize().timeout(const Duration(milliseconds: 2500), onTimeout: () {
        throw TimeoutException('Luồng Native m3u8 phản hồi chậm');
      });

      _controller!.addListener(() {
        if (mounted) setState(() {});
      });

      _controller!.play();
      _startHideControlsTimer();

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

  void _startHideControlsTimer() {
    _hideControlsTimer?.cancel();
    _hideControlsTimer = Timer(const Duration(seconds: 4), () {
      if (mounted && _isPlaying) {
        setState(() { _showControls = false; });
      }
    });
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
    if (_showControls) _startHideControlsTimer();
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
    _startHideControlsTimer();
  }

  void _seekRelative(int seconds) {
    if (_controller == null || !_controller!.value.isInitialized) return;
    final current = _controller!.value.position;
    final target = current + Duration(seconds: seconds);
    _controller!.seekTo(target);
    _startHideControlsTimer();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return duration.inHours > 0 ? '${twoDigits(duration.inHours)}:$minutes:$seconds' : '$minutes:$seconds';
  }

  @override
  void dispose() {
    _hideControlsTimer?.cancel();
    // Dừng triệt tiêu Native Video Player chạy ngầm và giải phóng bộ nhớ
    try {
      _controller?.pause();
      _controller?.dispose();
      _controller = null;
    } catch (_) {}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_useEmbedFallback) {
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
        body: WebviewFallbackPlayer(embedUrl: widget.episode.embed),
      );
    }

    final isInitialized = _controller != null && _controller!.value.isInitialized;
    final position = isInitialized ? _controller!.value.position : Duration.zero;
    final duration = isInitialized ? _controller!.value.duration : Duration.zero;

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
        onTap: _toggleControls,
        behavior: HitTestBehavior.opaque,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(
              child: isInitialized
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
                            style: TextStyle(color: Colors.white70, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
            ),

            if (isInitialized && _showControls)
              Positioned.fill(
                child: Container(
                  color: Colors.black45,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            iconSize: 44,
                            icon: const Icon(Icons.replay_10_rounded, color: Colors.white),
                            onPressed: () => _seekRelative(-10),
                          ),
                          const SizedBox(width: 32),
                          IconButton(
                            iconSize: 64,
                            icon: Icon(
                              _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                              color: const Color(0xFF00E5FF),
                            ),
                            onPressed: _togglePlayPause,
                          ),
                          const SizedBox(width: 32),
                          IconButton(
                            iconSize: 44,
                            icon: const Icon(Icons.forward_10_rounded, color: Colors.white),
                            onPressed: () => _seekRelative(10),
                          ),
                        ],
                      ),

                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                activeTrackColor: const Color(0xFF00E5FF),
                                inactiveTrackColor: Colors.white24,
                                thumbColor: const Color(0xFF00E5FF),
                                trackHeight: 4,
                              ),
                              child: Slider(
                                value: position.inSeconds.toDouble().clamp(0.0, duration.inSeconds.toDouble()),
                                min: 0.0,
                                max: duration.inSeconds.toDouble() > 0 ? duration.inSeconds.toDouble() : 1.0,
                                onChanged: (value) {
                                  _controller!.seekTo(Duration(seconds: value.toInt()));
                                  _startHideControlsTimer();
                                },
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(_formatDuration(position), style: const TextStyle(color: Colors.white, fontSize: 12)),
                                Text(_formatDuration(duration), style: const TextStyle(color: Colors.white70, fontSize: 12)),
                              ],
                            ),
                          ],
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
