import 'package:cloud_firestore/cloud_firestore.dart';

class Payment {
  const Payment({
    required this.id,
    required this.bookingId,
    required this.paymentMethodCode,
    required this.amount,
    required this.status,
    this.providerTxnId,
    this.paidAt,
    this.createdAt,
  });

  final String id;
  final String bookingId;
  final String paymentMethodCode;
  final int amount;
  final String status;
  final String? providerTxnId;
  final DateTime? paidAt;
  final DateTime? createdAt;

  factory Payment.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    return Payment.fromMap(doc.id, doc.data() ?? {});
  }

  factory Payment.fromMap(String id, Map<String, dynamic> data) {
    return Payment(
      id: id,
      bookingId: data['bookingId'] as String? ?? data['booking_id'] as String? ?? '',
      paymentMethodCode: data['paymentMethodCode'] as String? ?? data['method_code'] as String? ?? '',
      amount: (data['amount'] as num?)?.toInt() ?? 0,
      status: data['status'] as String? ?? 'PENDING',
      providerTxnId: data['providerTxnId'] as String? ?? data['provider_txn_id'] as String?,
      paidAt: _date(data['paidAt'] ?? data['paid_at']),
      createdAt: _date(data['createdAt'] ?? data['created_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'bookingId': bookingId,
      'paymentMethodCode': paymentMethodCode,
      'amount': amount,
      'status': status,
      'providerTxnId': providerTxnId,
      'paidAt': paidAt == null ? null : Timestamp.fromDate(paidAt!),
      'createdAt': createdAt == null ? FieldValue.serverTimestamp() : Timestamp.fromDate(createdAt!),
    };
  }
}

class PaymentMethod {
  const PaymentMethod({
    required this.code,
    required this.name,
    required this.isActive,
    required this.sortOrder,
  });

  final String code;
  final String name;
  final bool isActive;
  final int sortOrder;

  factory PaymentMethod.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return PaymentMethod(
      code: doc.id,
      name: data['name'] as String? ?? doc.id,
      isActive: data['isActive'] as bool? ?? data['is_active'] as bool? ?? true,
      sortOrder: (data['sortOrder'] as num?)?.toInt() ?? (data['sort_order'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'isActive': isActive,
      'sortOrder': sortOrder,
    };
  }
}

DateTime? _date(Object? value) {
  if (value is Timestamp) return value.toDate();
  if (value is DateTime) return value;
  if (value is String) return DateTime.tryParse(value);
  return null;
}
