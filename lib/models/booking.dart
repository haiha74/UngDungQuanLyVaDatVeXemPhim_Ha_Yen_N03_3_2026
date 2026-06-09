import 'package:cloud_firestore/cloud_firestore.dart';

import 'booking_item.dart';
import 'ticket.dart';

class Booking {
  const Booking({
    required this.id,
    required this.bookingCode,
    required this.showtimeId,
    this.userId,
    this.guestName,
    this.paymentMethodCode,
    this.guestMail,
    required this.status,
    this.expiresAt,
    required this.holdId,
    required this.totalAmount,
    this.createdAt,
    this.paidAt,
    this.items = const [],
    this.tickets = const [],
  });

  final String id;
  final String bookingCode;
  final String showtimeId;
  final String? userId;
  final String? guestName;
  final String? paymentMethodCode;
  final String? guestMail;
  final String status;
  final DateTime? expiresAt;
  final String holdId;
  final int totalAmount;
  final DateTime? createdAt;
  final DateTime? paidAt;
  final List<BookingItem> items;
  final List<Ticket> tickets;

  factory Booking.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    return Booking.fromMap(doc.id, doc.data() ?? {});
  }

  factory Booking.fromMap(String id, Map<String, dynamic> data) {
    final itemMaps = (data['items'] as List<dynamic>? ?? const [])
        .whereType<Map<String, dynamic>>()
        .toList();
    final ticketMaps = (data['tickets'] as List<dynamic>? ?? const [])
        .whereType<Map<String, dynamic>>()
        .toList();

    return Booking(
      id: id,
      bookingCode: data['bookingCode'] as String? ?? data['booking_code'] as String? ?? id,
      showtimeId: data['showtimeId'] as String? ?? data['showtime_id'] as String? ?? '',
      userId: data['userId'] as String? ?? data['user_id'] as String?,
      guestName: data['guestName'] as String? ?? data['guest_name'] as String?,
      paymentMethodCode: data['paymentMethodCode'] as String? ?? data['payment_method_id'] as String?,
      guestMail: data['guestMail'] as String? ?? data['guest_mail'] as String?,
      status: data['status'] as String? ?? 'PENDING',
      expiresAt: _date(data['expiresAt'] ?? data['expires_at']),
      holdId: data['holdId'] as String? ?? data['hold_id'] as String? ?? '',
      totalAmount: (data['totalAmount'] as num?)?.toInt() ?? (data['total_amount'] as num?)?.toInt() ?? 0,
      createdAt: _date(data['createdAt'] ?? data['created_at']),
      paidAt: _date(data['paidAt'] ?? data['paid_at']),
      items: [
        for (var i = 0; i < itemMaps.length; i++) BookingItem.fromMap('$id-item-$i', itemMaps[i]),
      ],
      tickets: [
        for (var i = 0; i < ticketMaps.length; i++) Ticket.fromMap('$id-ticket-$i', ticketMaps[i]),
      ],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'bookingCode': bookingCode,
      'showtimeId': showtimeId,
      'userId': userId,
      'guestName': guestName,
      'paymentMethodCode': paymentMethodCode,
      'guestMail': guestMail,
      'status': status,
      'expiresAt': expiresAt == null ? null : Timestamp.fromDate(expiresAt!),
      'holdId': holdId,
      'totalAmount': totalAmount,
      'createdAt': createdAt == null ? FieldValue.serverTimestamp() : Timestamp.fromDate(createdAt!),
      'paidAt': paidAt == null ? null : Timestamp.fromDate(paidAt!),
      'items': items.map((item) => item.toMap()).toList(),
      'tickets': tickets.map((ticket) => ticket.toMap()).toList(),
    };
  }
}

DateTime? _date(Object? value) {
  if (value is Timestamp) return value.toDate();
  if (value is DateTime) return value;
  if (value is String) return DateTime.tryParse(value);
  return null;
}
