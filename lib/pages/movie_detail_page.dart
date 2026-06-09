import 'package:flutter/material.dart';

import '../models/movie.dart';
import '../models/room.dart';
import '../models/showtime.dart';
import '../services/movie_service.dart';
import '../widgets/app_background.dart';
import '../widgets/cinema_button.dart';
import '../widgets/formatters.dart';
import '../widgets/section_title.dart';
import 'booking_page.dart';

class MovieDetailPage extends StatefulWidget {
  const MovieDetailPage({super.key, required this.movie});

  final Movie movie;

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  final _service = MovieService();
  late Future<List<_ShowtimeRow>> _showtimes;

  @override
  void initState() {
    super.initState();
    _showtimes = _loadShowtimes();
  }

  Future<List<_ShowtimeRow>> _loadShowtimes() async {
    final showtimes = await _service.getShowtimesForMovie(widget.movie.id);
    final rows = <_ShowtimeRow>[];
    for (final showtime in showtimes) {
      rows.add(_ShowtimeRow(showtime, await _service.getRoom(showtime.roomId)));
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(widget.movie.title)),
      body: AppBackground(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
          children: [
            _PosterHeader(movie: widget.movie),
            const SizedBox(height: 18),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _InfoPill(icon: Icons.schedule, label: '${widget.movie.runtime} min'),
                _InfoPill(icon: Icons.local_activity, label: widget.movie.status.replaceAll('_', ' ')),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              widget.movie.description,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: scheme.onSurfaceVariant, height: 1.45),
            ),
            const SizedBox(height: 24),
            const SectionTitle(title: 'Showtimes'),
            const SizedBox(height: 10),
            FutureBuilder<List<_ShowtimeRow>>(
              future: _showtimes,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: Padding(padding: EdgeInsets.all(24), child: CircularProgressIndicator()));
                }
                final rows = snapshot.data ?? const <_ShowtimeRow>[];
                if (rows.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text('No open showtimes for this movie.', style: TextStyle(color: scheme.onSurfaceVariant)),
                    ),
                  );
                }
                return Column(
                  children: [
                    for (final row in rows)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _ShowtimeCard(
                          row: row,
                          onBook: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => BookingPage(movie: widget.movie, showtime: row.showtime, room: row.room),
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _PosterHeader extends StatelessWidget {
  const _PosterHeader({required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      height: 430,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: scheme.shadow.withValues(alpha: 0.3), blurRadius: 28, offset: const Offset(0, 16)),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Hero(
            tag: 'movie-poster-${movie.id}',
            child: Image.network(
              movie.posterUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: scheme.surfaceContainerHighest,
                child: Icon(Icons.local_movies, color: scheme.onSurfaceVariant, size: 60),
              ),
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  scheme.scrim.withValues(alpha: 0),
                  scheme.scrim.withValues(alpha: 0.78),
                ],
              ),
            ),
          ),
          Positioned(
            left: 18,
            right: 18,
            bottom: 18,
            child: Text(
              movie.title,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: scheme.onSurface, fontWeight: FontWeight.w900),
            ),
          ),
        ],
      ),
    );
  }
}

class _ShowtimeCard extends StatelessWidget {
  const _ShowtimeCard({required this.row, required this.onBook});

  final _ShowtimeRow row;
  final VoidCallback onBook;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: scheme.outline),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: scheme.primaryContainer,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(Icons.theaters, color: scheme.onPrimaryContainer),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(formatDateTime(row.showtime.startTime), style: TextStyle(color: scheme.onSurface, fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Text(
                  '${row.room?.roomName ?? 'Room'} • ${row.room?.screenType ?? '2D'} • ${formatMoney(row.showtime.basePrice)}',
                  style: TextStyle(color: scheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
          CinemaButton(label: 'Book', icon: Icons.event_seat, onPressed: onBook),
        ],
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Chip(
      backgroundColor: scheme.surfaceContainerHighest,
      avatar: Icon(icon, size: 18, color: scheme.primary),
      label: Text(label, style: TextStyle(color: scheme.onSurface)),
      side: BorderSide(color: scheme.outline),
    );
  }
}

class _ShowtimeRow {
  const _ShowtimeRow(this.showtime, this.room);

  final Showtime showtime;
  final Room? room;
}
