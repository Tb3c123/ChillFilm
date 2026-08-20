import 'package:equatable/equatable.dart';
import '../../domain/entities/movie_detail_entity.dart';
import '../../domain/usecases/get_movie_detail.dart';

abstract class DetailState extends Equatable {
  const DetailState();
  @override
  List<Object?> get props => [];
}

class DetailLoadingState extends DetailState {}

class DetailLoadedState extends DetailState {
  final MovieDetailEntity movieDetail;
  final int selectedServerIndex;

  const DetailLoadedState({
    required this.movieDetail,
    this.selectedServerIndex = 0,
  });

  @override
  List<Object?> get props => [movieDetail, selectedServerIndex];
}

class DetailErrorState extends DetailState {
  final String message;
  const DetailErrorState(this.message);
  @override
  List<Object?> get props => [message];
}

class DetailBloc {
  final GetMovieDetailUseCase getMovieDetailUseCase;

  DetailBloc(this.getMovieDetailUseCase);

  Future<DetailState> fetchDetail(String slug) async {
    try {
      final detail = await getMovieDetailUseCase.execute(slug);
      return DetailLoadedState(movieDetail: detail);
    } catch (e) {
      return DetailErrorState(e.toString());
    }
  }
}
