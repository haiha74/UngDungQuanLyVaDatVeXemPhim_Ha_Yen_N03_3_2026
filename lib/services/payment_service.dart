import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../data/sample_data.dart';
import '../models/booking.dart';
import '../models/payment.dart';

class PaymentService {
  PaymentService({FirebaseFirestore? firestore}) : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Future<List<PaymentMethod>> getPaymentMethods() async {
    try {
      final snapshot = await _firestore.collection('paymentMethods').orderBy('sortOrder').get();
      final methods = snapshot.docs.map(PaymentMethod.fromFirestore).where((method) => method.isActive).toList();
      if (methods.isNotEmpty) return methods;
    } catch (_) {
      // Fall back below.
    }
    return SampleData.paymentMethods;
  }

  Future<Payment> createPayment({
    required Booking booking,
    required PaymentMethod method,
  }) async {
    final payment = Payment(
      id: 'payment_${booking.id}',
      bookingId: booking.id,
      paymentMethodCode: method.code,
      amount: booking.totalAmount,
      status: 'SUCCESS',
      providerTxnId: 'DEMO${Random.secure().nextInt(900000) + 100000}',
      paidAt: DateTime.now(),
      createdAt: DateTime.now(),
    );

    debugPrint(
      '[PaymentService] createPayment: writing payments/${payment.id}, '
      'bookingId=${booking.id}, userId=${booking.userId}, amount=${payment.amount}',
    );
    try {
      await _firestore.collection('payments').doc(payment.id).set(payment.toMap());
      final savedDoc = await _firestore.collection('payments').doc(payment.id).get();
      debugPrint('[PaymentService] createPayment: Firestore write succeeded payments/${payment.id}, exists=${savedDoc.exists}');
    } on FirebaseException catch (error, stackTrace) {
      debugPrint(
        '[PaymentService] createPayment: Firestore write failed '
        'payments/${payment.id}, code=${error.code}, message=${error.message}',
      );
      debugPrintStack(stackTrace: stackTrace);
      rethrow;
    } catch (error, stackTrace) {
      debugPrint('[PaymentService] createPayment: unexpected failure payments/${payment.id}: $error');
      debugPrintStack(stackTrace: stackTrace);
      rethrow;
    }

    return payment;
  }
}
