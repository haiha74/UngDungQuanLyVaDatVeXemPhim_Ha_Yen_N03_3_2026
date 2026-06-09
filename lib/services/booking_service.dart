import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../models/booking.dart';
import '../models/booking_item.dart';
import '../models/seat.dart';
import '../models/showtime.dart';
import '../models/ticket.dart';

class BookingService {
  BookingService({FirebaseFirestore? firestore}) : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Future<Booking> createBooking({
    required Showtime showtime,
    required List<Seat> seats,
    required String guestName,
    required String guestEmail,
    String? userId,
  }) async {
    if (userId == null || userId.trim().isEmpty) {
      throw StateError('Cannot create booking without an authenticated Firebase userId.');
    }

    final bookingRef = _firestore.collection('bookings').doc();
    final bookingCode = _code('CB', 8);
    final totalAmount = showtime.basePrice * seats.length;
    final items = seats
        .map(
          (seat) => BookingItem(
            id: '${bookingRef.id}_${seat.id}',
            bookingId: bookingRef.id,
            seatId: seat.id,
            seatCode: seat.seatCode,
            price: showtime.basePrice,
          ),
        )
        .toList();

    final booking = Booking(
      id: bookingRef.id,
      bookingCode: bookingCode,
      showtimeId: showtime.id,
      userId: userId,
      guestName: guestName,
      guestMail: guestEmail,
      status: 'PENDING',
      expiresAt: DateTime.now().add(const Duration(minutes: 10)),
      holdId: _code('HOLD', 10),
      totalAmount: totalAmount,
      createdAt: DateTime.now(),
      items: items,
    );

    debugPrint(
      '[BookingService] createBooking: writing bookings/${bookingRef.id}, '
      'bookingCode=$bookingCode, userId=$userId, seats=${seats.length}, total=$totalAmount',
    );
    try {
      await bookingRef.set(booking.toMap());
      final savedDoc = await bookingRef.get();
      debugPrint(
        '[BookingService] createBooking: Firestore write succeeded '
        'bookings/${bookingRef.id}, exists=${savedDoc.exists}',
      );
    } on FirebaseException catch (error, stackTrace) {
      debugPrint(
        '[BookingService] createBooking: Firestore write failed '
        'bookings/${bookingRef.id}, code=${error.code}, message=${error.message}',
      );
      debugPrintStack(stackTrace: stackTrace);
      rethrow;
    } catch (error, stackTrace) {
      debugPrint('[BookingService] createBooking: unexpected failure bookings/${bookingRef.id}: $error');
      debugPrintStack(stackTrace: stackTrace);
      rethrow;
    }

    return booking;
  }

  Future<Booking?> getBookingByCode(String bookingCode) async {
    try {
      final snapshot = await _firestore
          .collection('bookings')
          .where('bookingCode', isEqualTo: bookingCode)
          .limit(1)
          .get();
      if (snapshot.docs.isNotEmpty) return Booking.fromFirestore(snapshot.docs.first);
    } on FirebaseException catch (error, stackTrace) {
      debugPrint(
        '[BookingService] getBookingByCode: Firestore read failed '
        'bookingCode=$bookingCode, code=${error.code}, message=${error.message}',
      );
      debugPrintStack(stackTrace: stackTrace);
    } catch (error, stackTrace) {
      debugPrint('[BookingService] getBookingByCode: unexpected failure bookingCode=$bookingCode: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
    return null;
  }

  Future<Booking> markPaid({
    required Booking booking,
    required String paymentMethodCode,
  }) async {
    final tickets = [
      for (final item in booking.items)
        Ticket(
          id: '${booking.id}_${item.seatId}',
          ticketCode: _code('TK', 10),
          qrContent: 'TICKET:${booking.bookingCode}:${item.seatCode}',
          status: 'ISSUED',
          createdAt: DateTime.now(),
          bookingId: booking.id,
          showtimeId: booking.showtimeId,
          seatId: item.seatId,
          seatCode: item.seatCode,
          price: item.price,
        ),
    ];

    final paidBooking = Booking(
      id: booking.id,
      bookingCode: booking.bookingCode,
      showtimeId: booking.showtimeId,
      userId: booking.userId,
      guestName: booking.guestName,
      paymentMethodCode: paymentMethodCode,
      guestMail: booking.guestMail,
      status: 'PAID',
      expiresAt: booking.expiresAt,
      holdId: booking.holdId,
      totalAmount: booking.totalAmount,
      createdAt: booking.createdAt,
      paidAt: DateTime.now(),
      items: booking.items,
      tickets: tickets,
    );

    debugPrint(
      '[BookingService] markPaid: writing bookings/${booking.id}, '
      'userId=${booking.userId}, tickets=${tickets.length}, paymentMethod=$paymentMethodCode',
    );
    try {
      final batch = _firestore.batch();
      final bookingRef = _firestore.collection('bookings').doc(booking.id);
      batch.set(bookingRef, paidBooking.toMap(), SetOptions(merge: true));
      for (final ticket in tickets) {
        debugPrint('[BookingService] markPaid: queue ticket tickets/${ticket.id}, seat=${ticket.seatCode}');
        batch.set(_firestore.collection('tickets').doc(ticket.id), ticket.toMap());
      }
      await batch.commit();
      final savedBooking = await bookingRef.get();
      debugPrint(
        '[BookingService] markPaid: Firestore batch succeeded '
        'bookings/${booking.id}, exists=${savedBooking.exists}',
      );
    } on FirebaseException catch (error, stackTrace) {
      debugPrint(
        '[BookingService] markPaid: Firestore batch failed '
        'bookings/${booking.id}, code=${error.code}, message=${error.message}',
      );
      debugPrintStack(stackTrace: stackTrace);
      rethrow;
    } catch (error, stackTrace) {
      debugPrint('[BookingService] markPaid: unexpected failure bookings/${booking.id}: $error');
      debugPrintStack(stackTrace: stackTrace);
      rethrow;
    }

    return paidBooking;
  }

  String _code(String prefix, int length) {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final random = Random.secure();
    final suffix = List.generate(length, (_) => chars[random.nextInt(chars.length)]).join();
    return '$prefix$suffix';
  }
}
