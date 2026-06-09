import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AdminService {
  AdminService({FirebaseFirestore? firestore}) : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  static const collections = [
    'movies',
    'showtimes',
    'rooms',
    'seats',
    'bookings',
    'tickets',
    'payments',
    'users',
  ];

  Future<bool> isCurrentUserAdmin() async {
    final role = await getCurrentUserRole();
    return role == 'ADMIN';
  }

  Future<String?> getCurrentUserRole() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      debugPrint('[AdminService] no authenticated user for role check');
      return null;
    }
    try {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      final role = doc.data()?['role'] as String?;
      debugPrint('[AdminService] uid=${user.uid}, role=$role');
      return role;
    } catch (error, stackTrace) {
      debugPrint('[AdminService] role check failed: $error');
      debugPrintStack(stackTrace: stackTrace);
      return null;
    }
  }

  Future<Map<String, int>> getDashboardCounts() async {
    final counts = <String, int>{};
    for (final collection in collections) {
      try {
        final snapshot = await _firestore.collection(collection).count().get();
        counts[collection] = snapshot.count ?? 0;
      } catch (error) {
        debugPrint('[AdminService] count failed for $collection: $error');
        counts[collection] = 0;
      }
    }
    return counts;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> watchCollection(String collection) {
    return _firestore.collection(collection).snapshots();
  }

  Future<void> createDocument(String collection, Map<String, dynamic> data, {String? id}) async {
    final ref = id == null || id.trim().isEmpty ? _firestore.collection(collection).doc() : _firestore.collection(collection).doc(id.trim());
    final cleaned = _clean(data);
    debugPrint('[AdminService] create collection=$collection documentId=${ref.id} data=$cleaned');
    await ref.set({
      ...cleaned,
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> updateDocument(String collection, String id, Map<String, dynamic> data) async {
    final cleaned = _clean(data);
    debugPrint('[AdminService] update collection=$collection documentId=$id data=$cleaned');
    await _firestore.collection(collection).doc(id).set(cleaned, SetOptions(merge: true));
  }

  Future<void> deleteDocument(String collection, String id) async {
    debugPrint('[AdminService] delete collection=$collection documentId=$id');
    await _firestore.collection(collection).doc(id).delete();
  }

  Future<void> generateSeatsForRoom({
    required String roomId,
    required int rows,
    required int cols,
    required String type,
  }) async {
    if (roomId.trim().isEmpty || rows <= 0 || cols <= 0) {
      throw ArgumentError('roomId, rows and cols are required');
    }

    debugPrint('[AdminService] generate seats roomId=$roomId rows=$rows cols=$cols type=$type');
    final batch = _firestore.batch();
    for (var row = 0; row < rows; row++) {
      final rowLabel = String.fromCharCode(65 + row);
      for (var col = 0; col < cols; col++) {
        final seatCode = '$rowLabel${col + 1}';
        final id = '${roomId}_$seatCode';
        final data = {
          'roomId': roomId,
          'rowLabel': rowLabel,
          'rowIndex': row,
          'colIndex': col,
          'seatCode': seatCode,
          'type': type.trim().isEmpty ? 'STANDARD' : type.trim(),
          'seatType': type.trim().isEmpty ? 'STANDARD' : type.trim(),
          'status': 'ACTIVE',
          'createdAt': FieldValue.serverTimestamp(),
        };
        debugPrint('[AdminService] queue seat collection=seats documentId=$id data=$data');
        batch.set(_firestore.collection('seats').doc(id), data, SetOptions(merge: true));
      }
    }
    await batch.commit();
  }

  Future<int> clearSeatsForRoom(String roomId) async {
    if (roomId.trim().isEmpty) throw ArgumentError('roomId is required');

    debugPrint('[AdminService] clear seats roomId=$roomId');
    final snapshot = await _firestore.collection('seats').where('roomId', isEqualTo: roomId).get();
    final batch = _firestore.batch();
    for (final doc in snapshot.docs) {
      debugPrint('[AdminService] queue delete collection=seats documentId=${doc.id}');
      batch.delete(doc.reference);
    }
    await batch.commit();
    return snapshot.docs.length;
  }

  Map<String, dynamic> _clean(Map<String, dynamic> data) {
    final cleaned = <String, dynamic>{};
    for (final entry in data.entries) {
      final value = entry.value;
      if (value is String) {
        final text = value.trim();
        if (text.isEmpty) continue;
        final number = num.tryParse(text);
        cleaned[entry.key] = number ?? text;
      } else if (value != null) {
        cleaned[entry.key] = value;
      }
    }
    return cleaned;
  }
}
