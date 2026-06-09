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
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
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
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [Color(0xFFE5383B), Color(0xFF7F1117)]),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    movieTitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                ),
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.qr_code_2, color: Colors.white, size: 34),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: const Color(0xFF17171B),
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 82, child: Text(label, style: const TextStyle(color: Colors.white54))),
          Expanded(
            child: Text(
              value.isEmpty ? '-' : value,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
