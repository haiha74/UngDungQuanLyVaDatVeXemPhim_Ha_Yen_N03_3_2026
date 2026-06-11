import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/movie.dart';
import '../models/room.dart';
import '../models/seat.dart';
import '../models/showtime.dart';
import '../services/booking_service.dart';
import '../services/movie_service.dart';
import '../widgets/app_background.dart';
import '../widgets/cinema_button.dart';
import '../widgets/formatters.dart';
import '../widgets/section_title.dart';
import 'payment_page.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({
    super.key,
    required this.movie,
    required this.showtime,
    required this.room,
  });

  final Movie movie;
  final Showtime showtime;
  final Room? room;

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final _movieService = MovieService();
  final _bookingService = BookingService();
  final Set<String> _selectedSeatIds = {};
  late Future<_SeatMapData> _seatMap;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _seatMap = _loadSeatMap();
  }

  Future<_SeatMapData> _loadSeatMap() async {
    final seats = await _movieService.getSeatsForRoom(widget.showtime.roomId);
    final soldSeatIds = await _movieService.getSoldSeatIds(widget.showtime.id);
    return _SeatMapData(seats, soldSeatIds);
  }

  Future<void> _continueToPayment() async {
    if (_selectedSeatIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Select at least one seat.')));
      return;
    }

    setState(() => _submitting = true);
    try {
      final authUser = FirebaseAuth.instance.currentUser;
      if (authUser == null) {
        throw StateError('You must be logged in before booking tickets.');
      }
      final guestName = authUser.displayName ?? authUser.email ?? 'User';
      final guestEmail = authUser.email ?? '';
      final data = await _seatMap;
      final selectedSeats = data.seats.where((seat) => _selectedSeatIds.contains(seat.id)).toList();
      debugPrint(
        '[BookingPage] create booking requested: uid=${authUser.uid}, '
        'showtime=${widget.showtime.id}, seats=${selectedSeats.map((seat) => seat.seatCode).join(',')}',
      );
      final booking = await _bookingService.createBooking(
        showtime: widget.showtime,
        seats: selectedSeats,
        guestName: guestName,
        guestEmail: guestEmail,
        userId: authUser.uid,
      );
      debugPrint('[BookingPage] booking saved: bookingId=${booking.id}, userId=${booking.userId}');
      if (!mounted) return;
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => PaymentPage(
            movie: widget.movie,
            showtime: widget.showtime,
            room: widget.room,
            booking: booking,
          ),
        ),
      );
    } catch (error, stackTrace) {
      debugPrint('[BookingPage] booking save failed: $error');
      debugPrintStack(stackTrace: stackTrace);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not save booking: $error')),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final total = widget.showtime.basePrice * _selectedSeatIds.length;

    return Scaffold(
      appBar: AppBar(title: const Text('Choose seats')),
      body: AppBackground(
        child: FutureBuilder<_SeatMapData>(
          future: _seatMap,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            final data = snapshot.data;
            if (data == null) return errorView('Could not load seats.');

            final selectedSeats = data.seats.where((seat) => _selectedSeatIds.contains(seat.id)).toList()
              ..sort((a, b) => a.seatCode.compareTo(b.seatCode));

            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 126),
              children: [
                _BookingHeader(movie: widget.movie.title, detail: '${formatDateTime(widget.showtime.startTime)} • ${widget.room?.roomName ?? 'Room'}'),
                const SizedBox(height: 18),
                const SectionTitle(title: 'Select seats'),
                const SizedBox(height: 12),
                Container(
                  height: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    gradient: LinearGradient(colors: [scheme.surfaceContainerHighest, scheme.surface]),
                    boxShadow: [
                      BoxShadow(color: scheme.primary.withValues(alpha: 0.22), blurRadius: 28),
                    ],
                  ),
                  child: Text('SCREEN', style: TextStyle(color: scheme.onSurface, fontWeight: FontWeight.w900, letterSpacing: 1.2)),
                ),
                const SizedBox(height: 20),
                _SeatGrid(
                  seats: data.seats,
                  soldSeatIds: data.soldSeatIds,
                  selectedSeatIds: _selectedSeatIds,
                  onToggle: (seat) {
                    setState(() {
                      if (_selectedSeatIds.contains(seat.id)) {
                        _selectedSeatIds.remove(seat.id);
                      } else {
                        _selectedSeatIds.add(seat.id);
                      }
                    });
                  },
                ),
                const SizedBox(height: 18),
                const _SeatLegend(),
                const SizedBox(height: 18),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: scheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: scheme.outline),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Selected seats', style: TextStyle(color: scheme.onSurface, fontWeight: FontWeight.w900)),
                      const SizedBox(height: 10),
                      if (selectedSeats.isEmpty)
                        Text('Tap seats to add them to your booking.', style: TextStyle(color: scheme.onSurfaceVariant))
                      else
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            for (final seat in selectedSeats)
                              Chip(
                                label: Text(seat.seatCode),
                                backgroundColor: scheme.primary,
                                labelStyle: TextStyle(color: scheme.onPrimary, fontWeight: FontWeight.w800),
                              ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
      bottomSheet: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          decoration: BoxDecoration(
            color: scheme.surface,
            border: Border(top: BorderSide(color: scheme.outline)),
            boxShadow: [BoxShadow(color: scheme.shadow.withValues(alpha: 0.28), blurRadius: 20)],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${_selectedSeatIds.length} selected', style: TextStyle(color: scheme.onSurfaceVariant)),
                    Text(formatMoney(total), style: Theme.of(context).textTheme.titleMedium?.copyWith(color: scheme.onSurface, fontWeight: FontWeight.w900)),
                  ],
                ),
              ),
              CinemaButton(
                label: 'Payment',
                icon: Icons.payment,
                loading: _submitting,
                onPressed: _submitting ? null : _continueToPayment,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BookingHeader extends StatelessWidget {
  const _BookingHeader({required this.movie, required this.detail});

  final String movie;
  final String detail;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: scheme.outline),
      ),
      child: Row(
        children: [
          Icon(Icons.local_movies, color: scheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(movie, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: scheme.onSurface, fontWeight: FontWeight.w900)),
                const SizedBox(height: 4),
                Text(detail, style: TextStyle(color: scheme.onSurfaceVariant)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SeatGrid extends StatelessWidget {
  const _SeatGrid({
    required this.seats,
    required this.soldSeatIds,
    required this.selectedSeatIds,
    required this.onToggle,
  });

  final List<Seat> seats;
  final Set<String> soldSeatIds;
  final Set<String> selectedSeatIds;
  final ValueChanged<Seat> onToggle;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final sortedSeats = [...seats]..sort((a, b) {
        final rowCompare = a.rowIndex.compareTo(b.rowIndex);
        return rowCompare == 0 ? a.colIndex.compareTo(b.colIndex) : rowCompare;
      });
    final columns = sortedSeats.map((seat) => seat.colIndex).fold(0, (max, col) => col > max ? col : max) + 1;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: sortedSeats.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        final seat = sortedSeats[index];
        final sold = soldSeatIds.contains(seat.id);
        final selected = selectedSeatIds.contains(seat.id);
        final isVip = seat.seatType == 'VIP';
        final color = sold
        ? Colors.green
        : selected
            ? Colors.red
            : isVip
                ? Colors.amber
                : Colors.grey.shade700;
        final foreground = Colors.white;

        return Tooltip(
          message: seat.seatCode,
          child: AnimatedScale(
            scale: selected ? 1.08 : 1,
            duration: const Duration(milliseconds: 180),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: selected ? scheme.primaryContainer : scheme.outline),
                boxShadow: selected ? [BoxShadow(color: scheme.primary.withValues(alpha: 0.3), blurRadius: 12)] : null,
              ),
              child: InkWell(
                onTap: sold ? null : () => onToggle(seat),
                borderRadius: BorderRadius.circular(8),
                child: Center(
                  child: Text(
                    seat.seatCode,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: sold ? scheme.onTertiary : foreground,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SeatLegend extends StatelessWidget {
  const _SeatLegend();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Wrap(
    spacing: 16,
    runSpacing: 8,
    children: const [
      _LegendDot(
        color: Colors.grey,
        label: 'Standard',
      ),
      _LegendDot(
        color: Colors.amber,
        label: 'VIP',
      ),
      _LegendDot(
        color: Colors.red,
        label: 'Selected',
      ),
      _LegendDot(
        color: Colors.green,
        label: 'Sold',
      ),
    ],
  );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: scheme.outline),
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: TextStyle(color: scheme.onSurfaceVariant)),
      ],
    );
  }
}

class _SeatMapData {
  const _SeatMapData(this.seats, this.soldSeatIds);

  final List<Seat> seats;
  final Set<String> soldSeatIds;
}
