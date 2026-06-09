import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/movie.dart';
import '../services/movie_service.dart';
import '../widgets/animated_movie_card.dart';
import '../widgets/app_background.dart';
import '../widgets/cinema_button.dart';
import '../widgets/section_title.dart';
import 'movie_detail_page.dart';
import 'movie_list_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final service = MovieService();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppBackground(
        child: StreamBuilder<List<Movie>>(
          stream: service.watchMovies(),
          initialData: MovieService.fallbackMovies,
          builder: (context, snapshot) {
            final movies = snapshot.data ?? const <Movie>[];
            if (movies.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Text(
                    'Chưa có phim. Vui lòng thêm phim trong Admin.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
              );
            }
            final featured = movies.first;

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 22),
                    child: _HeroBanner(movie: featured),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SectionTitle(
                      title: 'Now showing',
                      actionLabel: 'See all',
                      onAction: () => Navigator.of(context).pushNamed(MovieListPage.routeName),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  sliver: SliverGrid.builder(
                    itemCount: movies.length,
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 210,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.58,
                    ),
                    itemBuilder: (context, index) {
                      final movie = movies[index];
                      return AnimatedMovieCard(
                        movie: movie,
                        onTap: () => _openMovie(context, movie),
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

  void _openMovie(BuildContext context, Movie movie) {
    Navigator.of(context).push(
      PageRouteBuilder<void>(
        pageBuilder: (context, animation, secondaryAnimation) => MovieDetailPage(movie: movie),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final offset = Tween(begin: const Offset(0, 0.04), end: Offset.zero).animate(animation);
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(position: offset, child: child),
          );
        },
      ),
    );
  }
}

class _HeroBanner extends StatelessWidget {
  const _HeroBanner({required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 360,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.45),
            blurRadius: 30,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            movie.posterUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              color: const Color(0xFF202026),
              child: const Icon(Icons.local_movies, color: Colors.white54, size: 60),
            ),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Color(0xDD050506)],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Featured',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: const Color(0xFFFFB3A6),
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  movie.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                ),
                const SizedBox(height: 10),
                Text(
                  '${movie.runtime} min  •  ${FirebaseAuth.instance.currentUser?.email ?? 'Cinema member'}',
                  style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),
                CinemaButton(
                  label: 'Mua vé',
                  icon: Icons.event_seat,
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => MovieDetailPage(movie: movie)),
                  ),
                ),
              ],
            ),
          ), 
        ],
      ),
    );
  }
}
