import 'package:cloud_firestore/cloud_firestore.dart';

class Ticket {
  const Ticket({
    required this.id,
    required this.ticketCode,
    required this.qrContent,
    required this.status,
    this.checkedInAt,
    this.checkedInBy,
    this.createdAt,
    required this.bookingId,
    required this.showtimeId,
    required this.seatId,
    required this.seatCode,
    required this.price,
  });

  final String id;
  final String ticketCode;
  final String qrContent;
  final String status;
  final DateTime? checkedInAt;
  final String? checkedInBy;
  final DateTime? createdAt;
  final String bookingId;
  final String showtimeId;
  final String seatId;
  final String seatCode;
  final int price;

  factory Ticket.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    return Ticket.fromMap(doc.id, doc.data() ?? {});
  }

  factory Ticket.fromMap(String id, Map<String, dynamic> data) {
    return Ticket(
      id: id,
      ticketCode: data['ticketCode'] as String? ?? data['ticket_code'] as String? ?? '',
      qrContent: data['qrContent'] as String? ?? data['qr_content'] as String? ?? '',
      status: data['status'] as String? ?? 'ISSUED',
      checkedInAt: _date(data['checkedInAt'] ?? data['checked_in_at']),
      checkedInBy: data['checkedInBy'] as String? ?? data['checked_in_by'] as String?,
      createdAt: _date(data['createdAt'] ?? data['created_at']),
      bookingId: data['bookingId'] as String? ?? data['booking_id'] as String? ?? '',
      showtimeId: data['showtimeId'] as String? ?? data['showtime_id'] as String? ?? '',
      seatId: data['seatId'] as String? ?? data['seat_id'] as String? ?? '',
      seatCode: data['seatCode'] as String? ?? data['seat_code'] as String? ?? '',
      price: (data['price'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ticketCode': ticketCode,
      'qrContent': qrContent,
      'status': status,
      'checkedInAt': checkedInAt == null ? null : Timestamp.fromDate(checkedInAt!),
      'checkedInBy': checkedInBy,
      'createdAt': createdAt == null ? FieldValue.serverTimestamp() : Timestamp.fromDate(createdAt!),
      'bookingId': bookingId,
      'showtimeId': showtimeId,
      'seatId': seatId,
      'seatCode': seatCode,
      'price': price,
    };
  }
}

DateTime? _date(Object? value) {
  if (value is Timestamp) return value.toDate();
  if (value is DateTime) return value;
  if (value is String) return DateTime.tryParse(value);
  return null;
}
