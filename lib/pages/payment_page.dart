import 'package:flutter/material.dart';

import '../models/booking.dart';
import '../models/movie.dart';
import '../models/payment.dart';
import '../models/room.dart';
import '../models/showtime.dart';
import '../services/booking_service.dart';
import '../services/payment_service.dart';
import '../widgets/app_background.dart';
import '../widgets/cinema_button.dart';
import '../widgets/formatters.dart';
import '../widgets/section_title.dart';
import '../widgets/ticket_card.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({
    super.key,
    required this.movie,
    required this.showtime,
    required this.room,
    required this.booking,
  });

  final Movie movie;
  final Showtime showtime;
  final Room? room;
  final Booking booking;

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final _paymentService = PaymentService();
  final _bookingService = BookingService();
  late Future<List<PaymentMethod>> _methods;
  PaymentMethod? _selectedMethod;
  Booking? _paidBooking;
  bool _paying = false;

  @override
  void initState() {
    super.initState();
    _methods = _paymentService.getPaymentMethods();
  }

  Future<void> _confirmPayment() async {
    final method = _selectedMethod;
    if (method == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Choose a payment method.')));
      return;
    }

    setState(() => _paying = true);
    try {
      await _paymentService.createPayment(booking: widget.booking, method: method);
      final paidBooking = await _bookingService.markPaid(booking: widget.booking, paymentMethodCode: method.code);
      debugPrint('[PaymentPage] payment confirmed: bookingId=${paidBooking.id}, userId=${paidBooking.userId}, tickets=${paidBooking.tickets.length}');
      if (mounted) setState(() => _paidBooking = paidBooking);
    } catch (error, stackTrace) {
      debugPrint('[PaymentPage] payment/ticket write failed: $error');
      debugPrintStack(stackTrace: stackTrace);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not confirm payment: $error')));
    } finally {
      if (mounted) setState(() => _paying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final paidBooking = _paidBooking;
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: Text(paidBooking == null ? 'Payment' : 'Ticket')),
      body: AppBackground(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            _OrderSummary(movie: widget.movie, showtime: widget.showtime, room: widget.room, booking: widget.booking),
            const SizedBox(height: 18),
            if (paidBooking == null)
              FutureBuilder<List<PaymentMethod>>(
                future: _methods,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: Padding(padding: EdgeInsets.all(24), child: CircularProgressIndicator()));
                  }
                  final methods = snapshot.data ?? const <PaymentMethod>[];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SectionTitle(title: 'Payment method'),
                      const SizedBox(height: 10),
                      for (final method in methods)
                        _PaymentMethodCard(
                          method: method,
                          selected: _selectedMethod?.code == method.code,
                          onTap: () => setState(() => _selectedMethod = method),
                        ),
                      const SizedBox(height: 12),
                      CinemaButton(
                        label: 'Confirm paid',
                        icon: Icons.check_circle_outline,
                        loading: _paying,
                        expanded: true,
                        onPressed: _paying ? null : _confirmPayment,
                      ),
                    ],
                  );
                },
              )
            else
              _TicketSuccess(movie: widget.movie, showtime: widget.showtime, booking: paidBooking),
          ],
        ),
      ),
    );
  }
}

class _OrderSummary extends StatelessWidget {
  const _OrderSummary({
    required this.movie,
    required this.showtime,
    required this.room,
    required this.booking,
  });

  final Movie movie;
  final Showtime showtime;
  final Room? room;
  final Booking booking;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF17171B),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF2B2B31)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(movie.title, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          Text('${formatDateTime(showtime.startTime)} • ${room?.roomName ?? 'Room'}', style: const TextStyle(color: Colors.white60)),
          const Divider(height: 26, color: Color(0xFF2B2B31)),
          _SummaryRow(label: 'Booking', value: booking.bookingCode),
          _SummaryRow(label: 'Seats', value: booking.items.map((item) => item.seatCode).join(', ')),
          _SummaryRow(label: 'Total', value: formatMoney(booking.totalAmount)),
        ],
      ),
    );
  }
}

class _PaymentMethodCard extends StatelessWidget {
  const _PaymentMethodCard({
    required this.method,
    required this.selected,
    required this.onTap,
  });

  final PaymentMethod method;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFF2B1114) : const Color(0xFF17171B),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: selected ? const Color(0xFFE5383B) : const Color(0xFF2B2B31), width: selected ? 1.6 : 1),
            boxShadow: selected ? [BoxShadow(color: const Color(0xFFE5383B).withValues(alpha: 0.24), blurRadius: 20)] : null,
          ),
          child: Row(
            children: [
              AnimatedScale(
                scale: selected ? 1.1 : 1,
                duration: const Duration(milliseconds: 180),
                child: Icon(Icons.account_balance_wallet_outlined, color: selected ? const Color(0xFFFF6B35) : Colors.white70),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(method.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 3),
                    Text(method.code, style: const TextStyle(color: Colors.white54)),
                  ],
                ),
              ),
              Icon(selected ? Icons.radio_button_checked : Icons.radio_button_unchecked, color: selected ? const Color(0xFFFF6B35) : Colors.white38),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 92, child: Text(label, style: const TextStyle(color: Colors.white54))),
          Expanded(child: Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800))),
        ],
      ),
    );
  }
}

class _TicketSuccess extends StatelessWidget {
  const _TicketSuccess({
    required this.movie,
    required this.showtime,
    required this.booking,
  });

  final Movie movie;
  final Showtime showtime;
  final Booking booking;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.verified, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 8),
            Text('Payment confirmed', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w900)),
          ],
        ),
        const SizedBox(height: 14),
        for (final ticket in booking.tickets)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: TicketCard(
              movieTitle: movie.title,
              bookingCode: booking.bookingCode,
              seat: ticket.seatCode,
              ticketCode: ticket.ticketCode,
              status: ticket.status,
              totalAmount: booking.totalAmount,
              showtime: showtime.startTime,
              createdAt: booking.createdAt,
              paidAt: booking.paidAt,
            ),
          ),
        CinemaButton(
          label: 'Back home',
          icon: Icons.home_outlined,
          expanded: true,
          onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
        ),
      ],
    );
  }
}
