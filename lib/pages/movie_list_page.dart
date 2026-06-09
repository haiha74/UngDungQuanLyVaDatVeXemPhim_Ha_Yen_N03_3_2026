import 'package:flutter/material.dart';

import '../models/movie.dart';
import '../services/movie_service.dart';
import '../widgets/animated_movie_card.dart';
import '../widgets/app_background.dart';
import 'movie_detail_page.dart';

class MovieListPage extends StatefulWidget {
  const MovieListPage({super.key});

  static const routeName = '/movies';

  @override
  State<MovieListPage> createState() => _MovieListPageState();
}

class _MovieListPageState extends State<MovieListPage> {
  final _service = MovieService();
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: AppBackground(
        child: StreamBuilder<List<Movie>>(
          stream: _service.watchMovies(),
          initialData: MovieService.fallbackMovies,
          builder: (context, snapshot) {
            final sourceMovies = snapshot.data ?? const <Movie>[];
            final movies = sourceMovies.where((movie) => movie.title.toLowerCase().contains(_query.toLowerCase())).toList();

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
                    child: TextField(
                      onChanged: (value) => setState(() => _query = value),
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        hintText: 'Search movies',
                      ),
                    ),
                  ),
                ),
                if (sourceMovies.isEmpty)
                  SliverFillRemaining(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          'Chưa có phim. Vui lòng thêm phim trong Admin.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  )
                else if (movies.isEmpty)
                  SliverFillRemaining(
                    child: Center(
                      child: Text('Không tìm thấy phim phù hợp.', style: TextStyle(color: scheme.onSurfaceVariant)),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                    sliver: SliverGrid.builder(
                      itemCount: movies.length,
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 190,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 0.58,
                      ),
                      itemBuilder: (context, index) {
                        final movie = movies[index];
                        return AnimatedMovieCard(
                          movie: movie,
                          compact: true,
                          onTap: () => Navigator.of(context).push(
                            PageRouteBuilder<void>(
                              pageBuilder: (context, animation, secondaryAnimation) => MovieDetailPage(movie: movie),
                              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                return FadeTransition(opacity: animation, child: child);
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
