import 'package:equatable/equatable.dart';
import '../../domain/entities/movie_entity.dart';
import '../../domain/usecases/get_recent_movies.dart';

// EVENTS
abstract class HomeEvent extends Equatable {
  const HomeEvent();
  @override
  List<Object?> get props => [];
}

class FetchHomeMoviesEvent extends HomeEvent {
  final int page;
  const FetchHomeMoviesEvent({this.page = 1});
  @override
  List<Object?> get props => [page];
}

// STATES
abstract class HomeState extends Equatable {
  const HomeState();
  @override
  List<Object?> get props => [];
}

class HomeInitialState extends HomeState {}
class HomeLoadingState extends HomeState {}

class HomeLoadedState extends HomeState {
  final MovieEntity heroMovie;
  final List<MovieEntity> recentMovies;

  const HomeLoadedState({
    required this.heroMovie,
    required this.recentMovies,
  });

  @override
  List<Object?> get props => [heroMovie, recentMovies];
}

class HomeErrorState extends HomeState {
  final String message;
  const HomeErrorState(this.message);
  @override
  List<Object?> get props => [message];
}

// BLOC
class HomeBloc {
  final GetRecentMoviesUseCase getRecentMoviesUseCase;

  HomeBloc(this.getRecentMoviesUseCase);

  Future<HomeState> fetchHomeMovies({int page = 1}) async {
    try {
      final movies = await getRecentMoviesUseCase.execute(page: page);
      if (movies.isEmpty) {
        return const HomeErrorState('Không tìm thấy dữ liệu phim.');
      }
      return HomeLoadedState(
        heroMovie: movies.first,
        recentMovies: movies.sublist(1),
      );
    } catch (e) {
      return HomeErrorState(e.toString());
    }
  }
}
