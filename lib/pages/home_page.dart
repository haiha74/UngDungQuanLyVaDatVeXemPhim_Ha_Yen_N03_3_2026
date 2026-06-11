import 'package:flutter/material.dart';

import '../models/movie.dart';
import '../services/movie_service.dart';
import '../widgets/app_background.dart';
import '../widgets/cinema_button.dart';
import '../widgets/section_title.dart';
import 'about_page.dart';
import 'movie_detail_page.dart';
import 'movie_list_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _service = MovieService();
  final _sectionKey = GlobalKey();
  String _query = '';
  String _sectionStatus = 'NOW_SHOWING';

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: AppBackground(
        child: StreamBuilder<List<Movie>>(
          stream: _service.watchMovies(),
          initialData: MovieService.fallbackMovies,
          builder: (context, snapshot) {
            final movies = snapshot.data ?? const <Movie>[];
            if (movies.isEmpty) {
              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(child: _HomeHeader(onQueryChanged: _setQuery, onProfile: _openProfile, onQr: _showSoon)),
                  SliverFillRemaining(
                    hasScrollBody: false,
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
                  ),
                ],
              );
            }

            final searchedMovies = _filterByQuery(movies);
            final sectionMovies = _moviesForSection(searchedMovies, movies);

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _HomeHeader(onQueryChanged: _setQuery, onProfile: _openProfile, onQr: _showSoon)),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 6, 16, 18),
                    child: _CategoryGrid(
                      onSelected: _handleCategory,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: _FeaturedCarousel(
                    movies: searchedMovies.isEmpty ? movies : searchedMovies,
                    onMovieTap: _openMovie,
                  ),
                ),
                SliverToBoxAdapter(
                  key: _sectionKey,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 22, 16, 8),
                    child: SectionTitle(
                      title: _sectionStatus == 'COMING_SOON' ? 'Coming soon' : 'Now showing',
                      actionLabel: 'See all',
                      onAction: () => Navigator.of(context).pushNamed(MovieListPage.routeName),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: _HorizontalMovieList(
                    movies: sectionMovies,
                    fallbackMessage: _sectionStatus == 'COMING_SOON' ? 'Chưa có phim sắp chiếu.' : 'Chưa có phim đang chiếu.',
                    onMovieTap: _openMovie,
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 28)),
              ],
            );
          },
        ),
      ),
    );
  }

  List<Movie> _filterByQuery(List<Movie> movies) {
    final query = _query.trim().toLowerCase();
    if (query.isEmpty) return movies;
    return movies.where((movie) {
      return movie.title.toLowerCase().contains(query) ||
          movie.description.toLowerCase().contains(query) ||
          movie.status.toLowerCase().contains(query);
    }).toList();
  }

  List<Movie> _moviesForSection(List<Movie> searchedMovies, List<Movie> allMovies) {
    final source = searchedMovies.isEmpty && _query.trim().isNotEmpty ? allMovies : searchedMovies;
    final filtered = source.where((movie) => movie.status.toUpperCase() == _sectionStatus).toList();
    return filtered.isEmpty && _sectionStatus == 'NOW_SHOWING' ? source : filtered;
  }

  void _setQuery(String value) {
    setState(() => _query = value);
  }

  void _handleCategory(_HomeCategory category) {
    switch (category.action) {
      case _CategoryAction.nowShowing:
        setState(() => _sectionStatus = 'NOW_SHOWING');
        _scrollToSection();
        return;
      case _CategoryAction.comingSoon:
        setState(() => _sectionStatus = 'COMING_SOON');
        _scrollToSection();
        return;
      case _CategoryAction.all:
        Navigator.of(context).pushNamed(MovieListPage.routeName);
        return;
      case _CategoryAction.soon:
        _showSoon();
        return;
    }
  }

  void _scrollToSection() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = _sectionKey.currentContext;
      if (context == null) return;
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutCubic,
        alignment: 0.12,
      );
    });
  }

  void _showSoon() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Sẽ sớm phát triển')));
  }

  void _openProfile() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const AboutPage(showAppBar: true)),
    );
  }

  void _openMovie(Movie movie) {
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

class _HomeHeader extends StatelessWidget {
  const _HomeHeader({
    required this.onQueryChanged,
    required this.onProfile,
    required this.onQr,
  });

  final ValueChanged<String> onQueryChanged;
  final VoidCallback onProfile;
  final VoidCallback onQr;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
        child: Row(
          children: [
            _HeaderIconButton(icon: Icons.qr_code_scanner, tooltip: 'Quét QR', onTap: onQr),
            const SizedBox(width: 10),
            Expanded(
              child: SizedBox(
                height: 50,
                child: TextField(
                  onChanged: onQueryChanged,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: 'Search movies, cinema...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: scheme.surfaceContainerHighest,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide(color: scheme.outline),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide(color: scheme.outline),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            _HeaderIconButton(icon: Icons.account_circle, tooltip: 'Tôi', onTap: onProfile),
          ],
        ),
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Tooltip(
      message: tooltip,
      child: Material(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: SizedBox(
            width: 50,
            height: 50,
            child: Icon(icon, color: scheme.primary),
          ),
        ),
      ),
    );
  }
}

class _CategoryGrid extends StatelessWidget {
  const _CategoryGrid({required this.onSelected});

  final ValueChanged<_HomeCategory> onSelected;

  static const categories = [
    _HomeCategory('Now Showing', Icons.movie_filter_outlined, _CategoryAction.nowShowing),
    _HomeCategory('Coming Soon', Icons.upcoming_outlined, _CategoryAction.comingSoon),
    _HomeCategory('Top Rated', Icons.star_rounded, _CategoryAction.soon),
    _HomeCategory('Genres', Icons.category_outlined, _CategoryAction.soon),
    _HomeCategory('Cinemas', Icons.theaters_outlined, _CategoryAction.soon),
    _HomeCategory('Offers', Icons.local_offer_outlined, _CategoryAction.soon),
    _HomeCategory('Events', Icons.celebration_outlined, _CategoryAction.soon),
    _HomeCategory('All', Icons.apps_rounded, _CategoryAction.all),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: categories.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.75,
      ),
      itemBuilder: (context, index) {
        final category = categories[index];
        return _CategoryTile(
          category: category,
          onTap: () => onSelected(category),
        );
      },
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({
    required this.category,
    required this.onTap,
  });

  final _HomeCategory category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Material(
      color: scheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(category.icon, color: scheme.primary, size: 30),
              const SizedBox(height: 8),
              Text(
                category.label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: scheme.onSurface,
                      fontWeight: FontWeight.w800,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeaturedCarousel extends StatelessWidget {
  const _FeaturedCarousel({
    required this.movies,
    required this.onMovieTap,
  });

  final List<Movie> movies;
  final ValueChanged<Movie> onMovieTap;

  @override
  Widget build(BuildContext context) {
    final displayMovies = movies.take(8).toList();
    if (displayMovies.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 330,
      child: PageView.builder(
        controller: PageController(viewportFraction: 0.88),
        itemCount: displayMovies.length,
        itemBuilder: (context, index) {
          final movie = displayMovies[index];
          return Padding(
            padding: EdgeInsets.only(left: index == 0 ? 16 : 8, right: 8),
            child: _FeaturedCard(movie: movie, onTap: () => onMovieTap(movie)),
          );
        },
      ),
    );
  }
}

class _FeaturedCard extends StatelessWidget {
  const _FeaturedCard({
    required this.movie,
    required this.onTap,
  });

  final Movie movie;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Material(
      color: scheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(24),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              movie.posterUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => ColoredBox(
                color: scheme.surfaceContainerHighest,
                child: Icon(Icons.local_movies, color: scheme.onSurfaceVariant, size: 58),
              ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    scheme.scrim.withValues(alpha: 0.08),
                    scheme.scrim.withValues(alpha: 0.78),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Featured',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(color: scheme.primary, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    movie.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: scheme.onSurface,
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${movie.runtime} min • ${movie.status.replaceAll('_', ' ')}',
                    style: TextStyle(color: scheme.onSurfaceVariant, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 14),
                  CinemaButton(label: 'Mua vé', icon: Icons.event_seat, onPressed: onTap),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HorizontalMovieList extends StatelessWidget {
  const _HorizontalMovieList({
    required this.movies,
    required this.fallbackMessage,
    required this.onMovieTap,
  });

  final List<Movie> movies;
  final String fallbackMessage;
  final ValueChanged<Movie> onMovieTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    if (movies.isEmpty) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: Text(fallbackMessage, style: TextStyle(color: scheme.onSurfaceVariant)),
      );
    }

    return SizedBox(
      height: 330,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: movies.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final movie = movies[index];
          return _NowShowingCard(movie: movie, onTap: () => onMovieTap(movie));
        },
      ),
    );
  }
}

class _NowShowingCard extends StatelessWidget {
  const _NowShowingCard({
    required this.movie,
    required this.onTap,
  });

  final Movie movie;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: 170,
      child: Material(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(18),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 0.72,
                child: Image.network(
                  movie.posterUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => ColoredBox(
                    color: scheme.surfaceContainerHighest,
                    child: Icon(Icons.local_movies, color: scheme.onSurfaceVariant),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: scheme.onSurface, fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 4),
                    Text('${movie.runtime} min', style: TextStyle(color: scheme.onSurfaceVariant)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeCategory {
  const _HomeCategory(this.label, this.icon, this.action);

  final String label;
  final IconData icon;
  final _CategoryAction action;
}

enum _CategoryAction {
  nowShowing,
  comingSoon,
  all,
  soon,
}
