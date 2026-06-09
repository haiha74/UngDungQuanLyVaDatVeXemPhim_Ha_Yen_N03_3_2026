import 'package:cloud_firestore/cloud_firestore.dart';

class Showtime {
  const Showtime({
    required this.id,
    required this.movieId,
    required this.roomId,
    required this.startTime,
    required this.endTime,
    required this.basePrice,
    required this.status,
    this.createdAt,
  });

  final String id;
  final String movieId;
  final String roomId;
  final DateTime startTime;
  final DateTime endTime;
  final int basePrice;
  final String status;
  final DateTime? createdAt;

  factory Showtime.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    return Showtime.fromMap(doc.id, doc.data() ?? {});
  }

  factory Showtime.fromMap(String id, Map<String, dynamic> data) {
    final now = DateTime.now();
    return Showtime(
      id: id,
      movieId: data['movieId'] as String? ?? data['movie_id'] as String? ?? '',
      roomId: data['roomId'] as String? ?? data['room_id'] as String? ?? '',
      startTime: _date(data['startTime'] ?? data['start_time']) ?? now,
      endTime: _date(data['endTime'] ?? data['end_time']) ?? now.add(const Duration(hours: 2)),
      basePrice: (data['basePrice'] as num?)?.toInt() ?? (data['base_price'] as num?)?.toInt() ?? 0,
      status: data['status'] as String? ?? 'OPEN',
      createdAt: _date(data['createdAt'] ?? data['created_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'movieId': movieId,
      'roomId': roomId,
      'startTime': Timestamp.fromDate(startTime),
      'endTime': Timestamp.fromDate(endTime),
      'basePrice': basePrice,
      'status': status,
      'createdAt': createdAt == null ? FieldValue.serverTimestamp() : Timestamp.fromDate(createdAt!),
    };
  }
}

DateTime? _date(Object? value) {
  if (value is Timestamp) return value.toDate();
  if (value is DateTime) return value;
  if (value is String) return DateTime.tryParse(value);
  return null;
}
