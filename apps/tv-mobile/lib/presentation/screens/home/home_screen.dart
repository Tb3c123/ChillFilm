import 'package:flutter/material.dart';
import '../../../core/network/api_client.dart';
import '../../../data/datasources/movie_remote_datasource.dart';
import '../../../data/datasources/movie_local_datasource.dart';
import '../../../data/repositories/movie_repository_impl.dart';
import '../../../core/storage/local_storage.dart';
import '../../../domain/usecases/get_recent_movies.dart';
import '../../../core/utils/device_util.dart';
import '../../state/home_bloc.dart';
import '../../widgets/tv_movie_card.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/error_view.dart';
import '../detail/movie_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeBloc _homeBloc;
  HomeState _state = HomeInitialState();

  @override
  void initState() {
    super.initState();
    final remoteDS = MovieRemoteDataSourceImpl(ApiClient());
    final localDS = MovieLocalDataSourceImpl(LocalStorage());
    final repo = MovieRepositoryImpl(remoteDataSource: remoteDS, localDataSource: localDS);
    _homeBloc = HomeBloc(GetRecentMoviesUseCase(repo));
    _loadData();
  }

  void _loadData() async {
    setState(() { _state = HomeLoadingState(); });
    final res = await _homeBloc.fetchHomeMovies();
    if (mounted) setState(() { _state = res; });
  }

  int _getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (DeviceUtil.isMobile(context)) return 2;
    if (DeviceUtil.isTablet(context)) return width < 900 ? 3 : 4;
    return 5;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = _getCrossAxisCount(context);
    final isTv = DeviceUtil.isTv(context);

    if (_state is HomeLoadingState || _state is HomeInitialState) {
      return const LoadingIndicator();
    }

    if (_state is HomeErrorState) {
      return ErrorView(
        message: (_state as HomeErrorState).message,
        onRetry: _loadData,
      );
    }

    final loadedState = _state as HomeLoadedState;
    final hero = loadedState.heroMovie;
    final movies = loadedState.recentMovies;

    return FocusTraversalGroup(
      policy: ReadingOrderTraversalPolicy(),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(screenWidth < 600 ? 12 : 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Banner Feature
            Focus(
              autofocus: isTv, // Chỉ item Hero Banner có autofocus=true khi trên TV
              canRequestFocus: isTv,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => MovieDetailScreen(slug: hero.slug)),
                  );
                },
                child: Container(
                  height: screenWidth < 600 ? 180 : 240,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: NetworkImage(hero.posterUrl),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.darken),
                    ),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE50914),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'PHIM TIÊU ĐIỂM',
                          style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        hero.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth < 600 ? 20 : 28,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${hero.year} • ${hero.genre}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Section Header
            Row(
              children: [
                Container(width: 4, height: 18, color: const Color(0xFF00E5FF)),
                const SizedBox(width: 8),
                const Text(
                  'PHIM MỚI CẬP NHẬT',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Movie Grid Traversal
            FocusTraversalGroup(
              policy: ReadingOrderTraversalPolicy(),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  childAspectRatio: screenWidth < 600 ? 0.72 : 0.68,
                  crossAxisSpacing: screenWidth < 600 ? 10 : 16,
                  mainAxisSpacing: screenWidth < 600 ? 10 : 16,
                ),
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  final movie = movies[index];
                  return TvMovieCard(
                    movie: movie,
                    autoFocus: false, // Các card phim để autoFocus=false tránh nhảy tiêu điểm
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => MovieDetailScreen(slug: movie.slug)),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
