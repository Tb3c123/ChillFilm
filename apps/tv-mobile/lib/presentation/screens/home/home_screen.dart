import 'package:flutter/material.dart';
import '../../../core/network/api_client.dart';
import '../../../data/datasources/movie_remote_datasource.dart';
import '../../../data/datasources/movie_local_datasource.dart';
import '../../../data/repositories/movie_repository_impl.dart';
import '../../../core/storage/local_storage.dart';
import '../../../domain/usecases/get_recent_movies.dart';
import '../../state/home_bloc.dart';
import '../../widgets/tv_movie_card.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/error_view.dart';
import '../detail/movie_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

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

  int _getCrossAxisCount(double width) {
    if (width < 600) return 2; // Điện thoại di động (16:9 / 20:9)
    if (width < 900) return 3; // Điện thoại gập (Foldable) / Tablet nhỏ
    if (width < 1200) return 4; // Tablet lớn / Màn hình ngang
    return 5; // Smart TV / Monitor 4K
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = _getCrossAxisCount(screenWidth);

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

    return SingleChildScrollView(
      padding: EdgeInsets.all(screenWidth < 600 ? 12 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero Banner
          Container(
            height: screenWidth < 600 ? 180 : 240,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: NetworkImage(hero.posterUrl),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(Colors.black.withValues(alpha: 0.5), BlendMode.darken),
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
          const SizedBox(height: 24),

          // Recent Movies Title
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

          // Responsive Grid View (Supports Phone 16:9, Foldable & TV)
          GridView.builder(
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
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => MovieDetailScreen(slug: movie.slug)),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
