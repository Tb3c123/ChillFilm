import 'package:equatable/equatable.dart';
import '../../domain/entities/movie_entity.dart';
import '../../domain/usecases/search_movies.dart';

abstract class SearchState extends Equatable {
  const SearchState();
  @override
  List<Object?> get props => [];
}

class SearchInitialState extends SearchState {}
class SearchLoadingState extends SearchState {}

class SearchLoadedState extends SearchState {
  final List<MovieEntity> movies;
  final String keyword;

  const SearchLoadedState({required this.movies, required this.keyword});

  @override
  List<Object?> get props => [movies, keyword];
}

class SearchErrorState extends SearchState {
  final String message;
  const SearchErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

class SearchBloc {
  final SearchMoviesUseCase searchMoviesUseCase;

  SearchBloc(this.searchMoviesUseCase);

  Future<SearchState> search(String keyword) async {
    if (keyword.trim().isEmpty) return SearchInitialState();
    try {
      final results = await searchMoviesUseCase.execute(keyword);
      return SearchLoadedState(movies: results, keyword: keyword);
    } catch (e) {
      return SearchErrorState(e.toString());
    }
  }
}
