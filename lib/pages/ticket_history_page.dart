import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/booking.dart';
import '../models/movie.dart';
import '../models/showtime.dart';
import '../models/ticket.dart';
import '../services/movie_service.dart';
import '../widgets/app_background.dart';
import '../widgets/cinema_button.dart';
import '../widgets/ticket_card.dart';

class TicketHistoryPage extends StatefulWidget {
  const TicketHistoryPage({super.key});

  static const routeName = '/history';

  @override
  State<TicketHistoryPage> createState() => _TicketHistoryPageState();
}

class _TicketHistoryPageState extends State<TicketHistoryPage> {
  final _firestore = FirebaseFirestore.instance;
  final _movieService = MovieService();
  late Future<List<_HistoryEntry>> _history;

  @override
  void initState() {
    super.initState();
    _history = _loadHistory();
  }

  Future<List<_HistoryEntry>> _loadHistory() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      debugPrint('[TicketHistoryPage] no authenticated user; returning empty history');
      return const [];
    }

    debugPrint('[TicketHistoryPage] loading bookings for userId=${user.uid}');
    final bookingSnapshot = await _firestore.collection('bookings').where('userId', isEqualTo: user.uid).get();
    final bookings = bookingSnapshot.docs.map(Booking.fromFirestore).toList()
      ..sort((a, b) => (b.createdAt ?? DateTime(0)).compareTo(a.createdAt ?? DateTime(0)));
    debugPrint('[TicketHistoryPage] Firestore returned ${bookings.length} bookings for userId=${user.uid}');

    final entries = <_HistoryEntry>[];
    for (final booking in bookings) {
      final ticketSnapshot = await _firestore.collection('tickets').where('bookingId', isEqualTo: booking.id).get();
      final tickets = ticketSnapshot.docs.map(Ticket.fromFirestore).toList();
      debugPrint('[TicketHistoryPage] booking=${booking.id}, code=${booking.bookingCode}, tickets=${tickets.length}');

      final showtime = await _movieService.getShowtime(booking.showtimeId);
      Movie? movie;
      if (showtime != null) {
        movie = await _movieService.getMovie(showtime.movieId);
      }

      if (tickets.isEmpty) {
        entries.add(_HistoryEntry(booking: booking, showtime: showtime, movie: movie));
      } else {
        for (final ticket in tickets) {
          entries.add(_HistoryEntry(booking: booking, ticket: ticket, showtime: showtime, movie: movie));
        }
      }
    }

    return entries;
  }

  Future<void> _refresh() async {
    setState(() => _history = _loadHistory());
    await _history;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: AppBackground(
        child: FutureBuilder<List<_HistoryEntry>>(
          future: _history,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.error_outline, size: 42, color: scheme.onSurfaceVariant),
                      const SizedBox(height: 12),
                      Text(
                        'Không thể tải lịch sử: ${snapshot.error}',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: scheme.onSurfaceVariant),
                      ),
                      const SizedBox(height: 12),
                      CinemaButton(label: 'Tải lại', icon: Icons.refresh, onPressed: _refresh),
                    ],
                  ),
                ),
              );
            }

            final entries = snapshot.data ?? const <_HistoryEntry>[];
            if (entries.isEmpty) {
              return RefreshIndicator(
                onRefresh: _refresh,
                child: ListView(
                  padding: const EdgeInsets.all(24),
                  children: [
                    const SizedBox(height: 120),
                    Icon(Icons.confirmation_number_outlined, size: 56, color: scheme.onSurfaceVariant),
                    const SizedBox(height: 12),
                    Text(
                      'Bạn chưa có vé nào.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: scheme.onSurface),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Sau khi thanh toán thành công, vé của bạn sẽ xuất hiện tại đây.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: scheme.onSurfaceVariant),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: _refresh,
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                itemCount: entries.length,
                separatorBuilder: (context, index) => const SizedBox(height: 14),
                itemBuilder: (context, index) => _HistoryCard(entry: entries[index]),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  const _HistoryCard({required this.entry});

  final _HistoryEntry entry;

  @override
  Widget build(BuildContext context) {
    final booking = entry.booking;
    final ticket = entry.ticket;
    final showtime = entry.showtime;
    final movie = entry.movie;

    return TicketCard(
      movieTitle: movie?.title ?? 'Movie unavailable',
      bookingCode: booking.bookingCode,
      seat: ticket?.seatCode ?? booking.items.map((item) => item.seatCode).join(', '),
      ticketCode: ticket?.ticketCode ?? 'Waiting for payment',
      status: ticket?.status ?? booking.status,
      totalAmount: booking.totalAmount,
      showtime: showtime?.startTime,
      createdAt: booking.createdAt,
      paidAt: booking.paidAt,
    );
  }
}

class _HistoryEntry {
  const _HistoryEntry({
    required this.booking,
    this.ticket,
    this.showtime,
    this.movie,
  });

  final Booking booking;
  final Ticket? ticket;
  final Showtime? showtime;
  final Movie? movie;
}
