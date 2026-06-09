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
    return Scaffold(
      backgroundColor: Colors.transparent,
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
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white70, height: 1.45),
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
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Text('No open showtimes for this movie.', style: TextStyle(color: Colors.white70)),
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
    return Container(
      height: 430,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.45), blurRadius: 28, offset: const Offset(0, 16)),
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
                color: const Color(0xFF202026),
                child: const Icon(Icons.local_movies, color: Colors.white54, size: 60),
              ),
            ),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Color(0xEE050506)],
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
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w900),
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
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF17171B),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF2B2B31)),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFFE5383B).withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.theaters, color: Color(0xFFFF6B35)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(formatDateTime(row.showtime.startTime), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Text('${row.room?.roomName ?? 'Room'} • ${row.room?.screenType ?? '2D'} • ${formatMoney(row.showtime.basePrice)}',
                    style: const TextStyle(color: Colors.white60)),
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
    return Chip(
      backgroundColor: const Color(0xFF1F1F25),
      avatar: Icon(icon, size: 18, color: const Color(0xFFFF6B35)),
      label: Text(label, style: const TextStyle(color: Colors.white)),
      side: const BorderSide(color: Color(0xFF34343B)),
    );
  }
}

class _ShowtimeRow {
  const _ShowtimeRow(this.showtime, this.room);

  final Showtime showtime;
  final Room? room;
}
