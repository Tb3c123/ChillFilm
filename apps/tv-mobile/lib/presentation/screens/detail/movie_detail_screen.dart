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
import '../player/mobile_video_player_screen.dart';
import '../../../core/utils/device_util.dart';
import '../../../data/models/movie_model.dart';
import '../../../domain/entities/movie_detail_entity.dart';

class MovieDetailScreen extends StatefulWidget {
  final String slug;

  const MovieDetailScreen({Key? key, required this.slug}) : super(key: key);

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  late DetailBloc _detailBloc;
  DetailState _state = DetailLoadingState();
  int _selectedServerIndex = 0;

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

  void _openPlayer(MovieDetailEntity detail, dynamic ep) {
    final movieModel = MovieModel(
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
    );

    final episodeModel = EpisodeModel(
      name: ep.name,
      slug: ep.slug,
      embed: ep.embed,
      m3u8: ep.m3u8,
    );

    final isTv = DeviceUtil.isTv(context);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => isTv
            ? TvVideoPlayerScreen(movie: movieModel, episode: episodeModel)
            : MobileVideoPlayerScreen(movie: movieModel, episode: episodeModel),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 700;

    if (_state is DetailLoadingState) {
      return const Scaffold(backgroundColor: Color(0xFF030508), body: LoadingIndicator());
    }

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
    final servers = detail.servers;
    final currentServer = servers.isNotEmpty && _selectedServerIndex < servers.length
        ? servers[_selectedServerIndex]
        : null;
    final episodes = currentServer != null ? currentServer.episodes : [];

    return Scaffold(
      backgroundColor: const Color(0xFF030508),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isMobile ? 16 : 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back Button
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.arrow_back, color: Colors.white),
                  SizedBox(width: 8),
                  Text('Quay lại', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Header Info Area (Responsive Row or Column for Fold/Phone)
            Flex(
              direction: isMobile ? Axis.vertical : Axis.horizontal,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Poster Image
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      detail.posterUrl,
                      width: isMobile ? 160 : 220,
                      height: isMobile ? 240 : 330,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 160,
                        height: 240,
                        color: Colors.grey[900],
                        child: const Icon(Icons.movie, color: Colors.white38, size: 48),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: isMobile ? 0 : 32, height: isMobile ? 20 : 0),

                // Detailed Metadata
                Expanded(
                  flex: isMobile ? 0 : 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        detail.name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isMobile ? 24 : 32,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        detail.originalName,
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
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
                          spacing: 20,
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

                      Text(
                        detail.description,
                        style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.5),
                      ),
                      const SizedBox(height: 20),

                      TvFocusableButton(
                        onPressed: () {
                          if (episodes.isNotEmpty) {
                            _openPlayer(detail, episodes.first);
                          }
                        },
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.play_arrow_rounded, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              'XEM NGAY TẬP 1',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Server Selector Bar
            if (servers.isNotEmpty) ...[
              const Text(
                'CHỌN NGUỒN PHÁT (SERVER):',
                style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(servers.length, (index) {
                    final isSelected = index == _selectedServerIndex;
                    return GestureDetector(
                      onTap: () {
                        setState(() { _selectedServerIndex = index; });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 12),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFF00E5FF) : const Color(0xFF121722),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? const Color(0xFF00E5FF) : Colors.white24,
                          ),
                        ),
                        child: Text(
                          servers[index].serverName,
                          style: TextStyle(
                            color: isSelected ? Colors.black : Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Episode Grid Selector
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF07090E),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'DANH SÁCH TẬP PHIM:',
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${episodes.length} Tập',
                        style: const TextStyle(color: Color(0xFF00E5FF), fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: List.generate(episodes.length, (idx) {
                      final ep = episodes[idx];
                      return GestureDetector(
                        onTap: () => _openPlayer(detail, ep),
                        child: Container(
                          width: isMobile ? 64 : 80,
                          height: 44,
                          decoration: BoxDecoration(
                            color: idx == 0 ? const Color(0xFFE50914) : const Color(0xFF121722),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: idx == 0 ? const Color(0xFFE50914) : Colors.white24,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              ep.name,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: isMobile ? 11 : 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, {bool isCyan = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white54, fontSize: 10)),
        const SizedBox(height: 2),
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
