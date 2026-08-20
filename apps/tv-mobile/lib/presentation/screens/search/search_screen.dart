import 'package:flutter/material.dart';
import '../../../core/network/api_client.dart';
import '../../../data/datasources/movie_remote_datasource.dart';
import '../../../data/datasources/movie_local_datasource.dart';
import '../../../data/repositories/movie_repository_impl.dart';
import '../../../core/storage/local_storage.dart';
import '../../../domain/usecases/search_movies.dart';
import '../../state/search_bloc.dart';
import '../../widgets/tv_movie_card.dart';
import '../../widgets/loading_indicator.dart';
import '../detail/movie_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late SearchBloc _searchBloc;
  SearchState _state = SearchInitialState();
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    final remoteDS = MovieRemoteDataSourceImpl(ApiClient());
    final localDS = MovieLocalDataSourceImpl(LocalStorage());
    final repo = MovieRepositoryImpl(remoteDataSource: remoteDS, localDataSource: localDS);
    _searchBloc = SearchBloc(SearchMoviesUseCase(repo));
  }

  void _onSearch(String keyword) async {
    setState(() { _state = SearchLoadingState(); });
    final res = await _searchBloc.search(keyword);
    if (mounted) setState(() { _state = res; });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAlignment.start,
        children: [
          const Text('TÌM KIẾM PHIM SMART TV', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.black)),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            onSubmitted: _onSearch,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Nhập tên phim, diễn viên...',
              hintStyle: const TextStyle(color: Colors.white38),
              prefixIcon: const Icon(Icons.search, color: Color(0xFF00E5FF)),
              filled: true,
              fillColor: const Color(0xFF121722),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 24),

          Expanded(
            child: _state is SearchLoadingState
                ? const LoadingIndicator()
                : _state is SearchLoadedState
                    ? GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5,
                          childAspectRatio: 0.68,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: (_state as SearchLoadedState).movies.length,
                        itemBuilder: (context, index) {
                          final movie = (_state as SearchLoadedState).movies[index];
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
                      )
                    : const Center(child: Text('Nhập từ khóa để bắt đầu tìm kiếm phim', style: TextStyle(color: Colors.white54))),
          ),
        ],
      ),
    );
  }
}
