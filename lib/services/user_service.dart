import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user.dart';

class UserService {
  UserService({FirebaseFirestore? firestore}) : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Future<AppUser> createOrUpdateGuest({
    required String fullName,
    required String email,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();
    final docId = normalizedEmail.replaceAll(RegExp(r'[^a-z0-9]+'), '_');
    final user = AppUser(
      id: docId,
      fullName: fullName.trim(),
      email: normalizedEmail,
      role: 'CUSTOMER',
      enabled: true,
      createdAt: DateTime.now(),
    );

    try {
      await _firestore.collection('users').doc(docId).set(user.toMap(), SetOptions(merge: true));
    } catch (_) {
      // Keep guest booking usable if Firestore is not writable yet.
    }

    return user;
  }

  Future<AppUser> saveAuthenticatedUser({
    required String uid,
    required String fullName,
    required String email,
  }) async {
    final user = AppUser(
      id: uid,
      fullName: fullName.trim(),
      email: email.trim().toLowerCase(),
      role: 'CUSTOMER',
      enabled: true,
      createdAt: DateTime.now(),
    );

    await _firestore.collection('users').doc(uid).set(user.toMap(), SetOptions(merge: true));
    return user;
  }
}
