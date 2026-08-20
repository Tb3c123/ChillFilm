import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../../data/models/movie_model.dart';

class MobileVideoPlayerScreen extends StatefulWidget {
  final MovieModel movie;
  final EpisodeModel episode;

  const MobileVideoPlayerScreen({
    Key? key,
    required this.movie,
    required this.episode,
  }) : super(key: key);

  @override
  State<MobileVideoPlayerScreen> createState() => _MobileVideoPlayerScreenState();
}

class _MobileVideoPlayerScreenState extends State<MobileVideoPlayerScreen> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    if (widget.episode.m3u8.isNotEmpty) {
      _controller = VideoPlayerController.networkUrl(Uri.parse(widget.episode.m3u8))
        ..initialize().then((_) {
          setState(() {});
          _controller!.play();
        });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('${widget.movie.name} - ${widget.episode.name}'),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: _controller != null && _controller!.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller!.value.aspectRatio,
                child: VideoPlayer(_controller!),
              )
            : const CircularProgressIndicator(color: Color(0xFF00E5FF)),
      ),
    );
  }
}
