import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../models/movie.dart';
import '../models/room.dart';
import '../models/seat.dart';
import '../models/showtime.dart';

class MovieService {
  MovieService({FirebaseFirestore? firestore}) : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;
  static List<Movie> get fallbackMovies => const [];

  Stream<List<Movie>> watchMovies() {
    debugPrint('[MovieService] watchMovies: listen Firestore movies only');
    return _watchMovies();
  }

  Stream<List<Movie>> _watchMovies() async* {
    try {
      await for (final snapshot in _firestore.collection('movies').orderBy('title').snapshots()) {
        final movies = snapshot.docs.map(Movie.fromFirestore).where((movie) => movie.title.trim().isNotEmpty).toList();
        debugPrint('[MovieService] watchMovies: Firestore returned ${movies.length} movies');
        yield movies;
      }
    } catch (error, stackTrace) {
      debugPrint('[MovieService] watchMovies: Firestore failed. Error: $error');
      debugPrintStack(stackTrace: stackTrace);
      yield const [];
    }
  }

  Future<List<Movie>> getMovies() async {
    try {
      debugPrint('[MovieService] getMovies: loading Firestore movies');
      final snapshot = await _firestore.collection('movies').orderBy('title').get().timeout(const Duration(seconds: 5));
      final movies = snapshot.docs.map(Movie.fromFirestore).where((movie) => movie.title.trim().isNotEmpty).toList();
      debugPrint('[MovieService] getMovies: Firestore returned ${movies.length} movies');
      return movies;
    } catch (error, stackTrace) {
      debugPrint('[MovieService] getMovies: Firestore failed. Error: $error');
      debugPrintStack(stackTrace: stackTrace);
      return const [];
    }
  }

  Future<Movie?> getMovie(String id) async {
    try {
      final doc = await _firestore.collection('movies').doc(id).get();
      if (doc.exists) return Movie.fromFirestore(doc);
    } catch (error, stackTrace) {
      debugPrint('[MovieService] getMovie failed id=$id: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
    return null;
  }

  Future<List<Showtime>> getShowtimesForMovie(String movieId) async {
    try {
      final snapshot = await _firestore
          .collection('showtimes')
          .where('movieId', isEqualTo: movieId)
          .get();
      final showtimes = snapshot.docs.map(Showtime.fromFirestore).toList()
        ..sort((a, b) => a.startTime.compareTo(b.startTime));
      debugPrint('[MovieService] getShowtimesForMovie movieId=$movieId returned ${showtimes.length}');
      return showtimes;
    } catch (error, stackTrace) {
      debugPrint('[MovieService] getShowtimesForMovie failed movieId=$movieId: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
    return const [];
  }

  Future<Showtime?> getShowtime(String id) async {
    try {
      final doc = await _firestore.collection('showtimes').doc(id).get();
      if (doc.exists) return Showtime.fromFirestore(doc);
    } catch (error, stackTrace) {
      debugPrint('[MovieService] getShowtime failed id=$id: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
    return null;
  }

  Future<Room?> getRoom(String id) async {
    try {
      final doc = await _firestore.collection('rooms').doc(id).get();
      if (doc.exists) return Room.fromFirestore(doc);
    } catch (error, stackTrace) {
      debugPrint('[MovieService] getRoom failed id=$id: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
    return null;
  }

  Future<List<Seat>> getSeatsForRoom(String roomId) async {
    try {
      final snapshot = await _firestore
          .collection('seats')
          .where('roomId', isEqualTo: roomId)
          .get();
      final seats = snapshot.docs.map(Seat.fromFirestore).toList()
        ..sort((a, b) {
          final row = a.rowIndex.compareTo(b.rowIndex);
          return row == 0 ? a.colIndex.compareTo(b.colIndex) : row;
        });
      debugPrint('[MovieService] getSeatsForRoom roomId=$roomId returned ${seats.length}');
      return seats;
    } catch (error, stackTrace) {
      debugPrint('[MovieService] getSeatsForRoom failed roomId=$roomId: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
    return const [];
  }

  Future<Set<String>> getSoldSeatIds(String showtimeId) async {
    try {
      final snapshot = await _firestore
          .collection('tickets')
          .where('showtimeId', isEqualTo: showtimeId)
          .where('status', whereIn: ['ISSUED', 'CHECKED_IN'])
          .get();
      return snapshot.docs.map((doc) => doc.data()['seatId'] as String? ?? '').where((id) => id.isNotEmpty).toSet();
    } catch (_) {
      return <String>{};
    }
  }
}
