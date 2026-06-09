import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  const AppUser({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
    required this.enabled,
    this.createdAt,
  });

  final String id;
  final String fullName;
  final String email;
  final String role;
  final bool enabled;
  final DateTime? createdAt;

  factory AppUser.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return AppUser(
      id: doc.id,
      fullName: data['fullName'] as String? ?? data['full_name'] as String? ?? '',
      email: data['email'] as String? ?? '',
      role: data['role'] as String? ?? 'CUSTOMER',
      enabled: data['enabled'] as bool? ?? true,
      createdAt: _date(data['createdAt'] ?? data['created_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'email': email,
      'role': role,
      'enabled': enabled,
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
