import 'package:cloud_firestore/cloud_firestore.dart';

class Movie {
  const Movie({
    required this.id,
    required this.title,
    required this.description,
    required this.runtime,
    required this.posterUrl,
    this.trailerUrl,
    required this.status,
    this.releaseDate,
    this.createdAt,
  });

  final String id;
  final String title;
  final String description;
  final int runtime;
  final String posterUrl;
  final String? trailerUrl;
  final String status;
  final DateTime? releaseDate;
  final DateTime? createdAt;

  factory Movie.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    return Movie.fromMap(doc.id, doc.data() ?? {});
  }

  factory Movie.fromMap(String id, Map<String, dynamic> data) {
    return Movie(
      id: id,
      title: data['title'] as String? ?? '',
      description: data['description'] as String? ?? '',
      runtime: (data['runtime'] as num?)?.toInt() ?? 0,
      posterUrl: data['posterUrl'] as String? ?? data['poster_url'] as String? ?? '',
      trailerUrl: data['trailerUrl'] as String? ?? data['trailer_url'] as String?,
      status: data['status'] as String? ?? 'NOW_SHOWING',
      releaseDate: _date(data['releaseDate'] ?? data['release_date']),
      createdAt: _date(data['createdAt'] ?? data['created_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'runtime': runtime,
      'posterUrl': posterUrl,
      'trailerUrl': trailerUrl,
      'status': status,
      'releaseDate': releaseDate == null ? null : Timestamp.fromDate(releaseDate!),
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
