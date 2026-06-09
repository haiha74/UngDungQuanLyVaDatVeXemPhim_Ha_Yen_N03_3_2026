import 'package:cloud_firestore/cloud_firestore.dart';

class Seat {
  const Seat({
    required this.id,
    required this.roomId,
    required this.seatCode,
    this.rowLabel = '',
    this.seatType = 'STANDARD',
    required this.rowIndex,
    required this.colIndex,
    this.status = 'ACTIVE',
  });

  final String id;
  final String roomId;
  final String seatCode;
  final String rowLabel;
  final String seatType;
  final int rowIndex;
  final int colIndex;
  final String status;

  factory Seat.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    return Seat.fromMap(doc.id, doc.data() ?? {});
  }

  factory Seat.fromMap(String id, Map<String, dynamic> data) {
    return Seat(
      id: id,
      roomId: data['roomId'] as String? ?? data['room_id'] as String? ?? '',
      seatCode: data['seatCode'] as String? ?? data['seat_code'] as String? ?? '',
      rowLabel: data['rowLabel'] as String? ?? '',
      seatType: data['type'] as String? ?? data['seatType'] as String? ?? data['seat_type'] as String? ?? 'STANDARD',
      rowIndex: (data['rowIndex'] as num?)?.toInt() ?? (data['row_index'] as num?)?.toInt() ?? 0,
      colIndex: (data['colIndex'] as num?)?.toInt() ?? (data['col_index'] as num?)?.toInt() ?? 0,
      status: data['status'] as String? ?? 'ACTIVE',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'roomId': roomId,
      'rowLabel': rowLabel,
      'seatCode': seatCode,
      'type': seatType,
      'seatType': seatType,
      'rowIndex': rowIndex,
      'colIndex': colIndex,
      'status': status,
    };
  }
}
