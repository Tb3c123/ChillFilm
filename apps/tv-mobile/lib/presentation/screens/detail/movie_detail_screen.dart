import 'package:flutter/material.dart';
import '../../../core/network/api_client.dart';
import '../../../data/datasources/movie_remote_datasource.dart';
import '../../../data/datasources/movie_local_datasource.dart';
import '../../../data/repositories/movie_repository_impl.dart';
import '../../../core/storage/local_storage.dart';
import '../../../domain/usecases/get_movie_detail.dart';
import '../../state/detail_bloc.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/error_view.dart';
import '../../widgets/tv_focusable_button.dart';
import '../player/tv_video_player_screen.dart';
import '../../../data/models/movie_model.dart';

class MovieDetailScreen extends StatefulWidget {
  final String slug;

  const MovieDetailScreen({Key? key, required this.slug}) : super(key: key);

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  late DetailBloc _detailBloc;
  DetailState _state = DetailLoadingState();

  @override
  void initState() {
    super.initState();
    final remoteDS = MovieRemoteDataSourceImpl(ApiClient());
    final localDS = MovieLocalDataSourceImpl(LocalStorage());
    final repo = MovieRepositoryImpl(remoteDataSource: remoteDS, localDataSource: localDS);
    _detailBloc = DetailBloc(GetMovieDetailUseCase(repo));
    _loadDetail();
  }

  void _loadDetail() async {
    setState(() { _state = DetailLoadingState(); });
    final res = await _detailBloc.fetchDetail(widget.slug);
    if (mounted) setState(() { _state = res; });
  }

  @override
  Widget build(BuildContext context) {
    if (_state is DetailLoadingState) return const Scaffold(backgroundColor: Color(0xFF030508), body: LoadingIndicator());

    if (_state is DetailErrorState) {
      return Scaffold(
        backgroundColor: const Color(0xFF030508),
        body: ErrorView(
          message: (_state as DetailErrorState).message,
          onRetry: _loadDetail,
        ),
      );
    }

    final detail = (_state as DetailLoadedState).movieDetail;
    final defaultServer = detail.servers.isNotEmpty ? detail.servers.first : null;
    final episodes = defaultServer != null ? defaultServer.episodes : [];

    return Scaffold(
      backgroundColor: const Color(0xFF030508),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAlignment.start,
          children: [
            // Back Button
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Row(
                children: [
                  Icon(Icons.arrow_back, color: Colors.white),
                  SizedBox(width: 8),
                  Text('Quay lại', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 24),

            Row(
              crossAxisAlignment: CrossAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(detail.posterUrl, width: 220, height: 330, fit: BoxFit.cover),
                ),
                const SizedBox(width: 32),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAlignment.start,
                    children: [
                      Text(detail.name, style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.black)),
                      Text(detail.originalName, style: const TextStyle(color: Colors.white54, fontSize: 14, italic: true)),
                      const SizedBox(height: 16),

                      // 7 Metadata Fields Grid
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF07090E),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFF00E5FF).withOpacity(0.3)),
                        ),
                        child: Wrap(
                          spacing: 24,
                          runSpacing: 12,
                          children: [
                            _buildInfoItem('1. Số Tập:', '${detail.totalEpisodes} Tập', isCyan: true),
                            _buildInfoItem('2. Thời Lượng:', detail.duration),
                            _buildInfoItem('3. Đạo Diễn:', detail.director),
                            _buildInfoItem('4. Năm Phát Hành:', detail.year, isCyan: true),
                            _buildInfoItem('5. Thể Loại:', detail.genre),
                            _buildInfoItem('6. Quốc Gia:', detail.country),
                            _buildInfoItem('7. Diễn Viên:', detail.casts),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      Text(detail.description, style: const TextStyle(color: Colors.white70, fontSize: 13)),
                      const SizedBox(height: 24),

                      TvFocusableButton(
                        onPressed: () {
                          if (episodes.isNotEmpty) {
                            final ep = episodes.first;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => TvVideoPlayerScreen(
                                  movie: MovieModel(
                                    id: detail.id,
                                    name: detail.name,
                                    slug: detail.slug,
                                    originalName: detail.originalName,
                                    thumbUrl: detail.thumbUrl,
                                    posterUrl: detail.posterUrl,
                                    totalEpisodes: detail.totalEpisodes,
                                    quality: 'HD',
                                    duration: detail.duration,
                                    director: detail.director,
                                    casts: detail.casts,
                                    genre: detail.genre,
                                    year: detail.year,
                                    country: detail.country,
                                    servers: const [],
                                  ),
                                  episode: EpisodeModel(name: ep.name, slug: ep.slug, embed: ep.embed, m3u8: ep.m3u8),
                                ),
                              ),
                            );
                          }
                        },
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.play_arrow_rounded, color: Colors.white),
                            SizedBox(width: 8),
                            Text('XEM NGAY TẬP 1', style: TextStyle(color: Colors.white, fontWeight: FontWeight.black)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, {bool isCyan = false}) {
    return Column(
      crossAxisAlignment: CrossAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white54, fontSize: 10)),
        Text(
          value,
          style: TextStyle(
            color: isCyan ? const Color(0xFF00E5FF) : Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
