import 'package:cloud_firestore/cloud_firestore.dart';

class Room {
  const Room({
    required this.id,
    required this.roomName,
    this.screenType = '2D',
    this.totalRows = 0,
    this.seatsPerRow = 0,
    this.status = 'ACTIVE',
    this.createdAt,
  });

  final String id;
  final String roomName;
  final String screenType;
  final int totalRows;
  final int seatsPerRow;
  final String status;
  final DateTime? createdAt;

  factory Room.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    return Room.fromMap(doc.id, doc.data() ?? {});
  }

  factory Room.fromMap(String id, Map<String, dynamic> data) {
    return Room(
      id: id,
      roomName: data['name'] as String? ?? data['roomName'] as String? ?? data['room_name'] as String? ?? '',
      screenType: data['screenType'] as String? ?? data['screen_type'] as String? ?? '2D',
      totalRows: (data['totalRows'] as num?)?.toInt() ?? 0,
      seatsPerRow: (data['seatsPerRow'] as num?)?.toInt() ?? 0,
      status: data['status'] as String? ?? 'ACTIVE',
      createdAt: _date(data['createdAt'] ?? data['created_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': roomName,
      'roomName': roomName,
      'screenType': screenType,
      'totalRows': totalRows,
      'seatsPerRow': seatsPerRow,
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
