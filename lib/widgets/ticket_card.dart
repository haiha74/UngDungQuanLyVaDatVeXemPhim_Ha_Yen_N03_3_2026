import 'package:flutter/material.dart';

import '../widgets/formatters.dart';

class TicketCard extends StatelessWidget {
  const TicketCard({
    super.key,
    required this.movieTitle,
    required this.bookingCode,
    required this.seat,
    required this.ticketCode,
    required this.status,
    required this.totalAmount,
    this.showtime,
    this.createdAt,
    this.paidAt,
  });

  final String movieTitle;
  final String bookingCode;
  final String seat;
  final String ticketCode;
  final String status;
  final int totalAmount;
  final DateTime? showtime;
  final DateTime? createdAt;
  final DateTime? paidAt;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: scheme.shadow.withValues(alpha: 0.22),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: scheme.primary,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    movieTitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: scheme.onPrimary,
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                ),
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: scheme.onPrimary.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.qr_code_2, color: scheme.onPrimary, size: 34),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: scheme.surfaceContainerHighest,
            child: Column(
              children: [
                _Row(label: 'Booking', value: bookingCode),
                _Row(label: 'Seat', value: seat),
                _Row(label: 'Ticket', value: ticketCode),
                _Row(label: 'Status', value: status),
                _Row(label: 'Total', value: formatMoney(totalAmount)),
                if (showtime != null) _Row(label: 'Showtime', value: formatDateTime(showtime!)),
                if (createdAt != null) _Row(label: 'Created', value: formatDateTime(createdAt!)),
                if (paidAt != null) _Row(label: 'Paid', value: formatDateTime(paidAt!)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 82, child: Text(label, style: TextStyle(color: scheme.onSurfaceVariant))),
          Expanded(
            child: Text(
              value.isEmpty ? '-' : value,
              style: TextStyle(color: scheme.onSurface, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
