class BookingItem {
  const BookingItem({
    required this.id,
    required this.bookingId,
    required this.seatId,
    required this.seatCode,
    required this.price,
  });

  final String id;
  final String bookingId;
  final String seatId;
  final String seatCode;
  final int price;

  factory BookingItem.fromMap(String id, Map<String, dynamic> data) {
    return BookingItem(
      id: id,
      bookingId: data['bookingId'] as String? ?? '',
      seatId: data['seatId'] as String? ?? '',
      seatCode: data['seatCode'] as String? ?? '',
      price: (data['price'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'bookingId': bookingId,
      'seatId': seatId,
      'seatCode': seatCode,
      'price': price,
    };
  }
}
