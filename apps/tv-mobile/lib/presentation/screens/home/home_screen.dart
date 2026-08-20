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

  @override
  Widget build(BuildContext context) {
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
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAlignment.start,
        children: [
          // Hero Banner
          Container(
            height: 240,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              image: DecorationImage(
                image: NetworkImage(hero.posterUrl),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.darken),
              ),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE50914),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text('PHIM TIÊU ĐIỂM', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.black)),
                ),
                const SizedBox(height: 8),
                Text(
                  hero.name,
                  style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.black),
                ),
                const SizedBox(height: 4),
                Text(
                  '${hero.year} • ${hero.genre}',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Recent Movies Title
          const Row(
            children: [
              Container(width: 4, height: 18, color: Color(0xFF00E5FF)),
              SizedBox(width: 8),
              Text(
                'PHIM MỚI CẬP NHẬT',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.black),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Horizontal Grid / Row
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              childAspectRatio: 0.68,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
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
