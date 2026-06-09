import '../models/movie.dart';
import '../models/payment.dart';
import '../models/room.dart';
import '../models/seat.dart';
import '../models/showtime.dart';

class SampleData {
  static final movies = [
    Movie(
      id: 'movie_doraemon',
      title: "Doraemon: Nobita's Sky Utopia",
      description: 'Phim hoat hinh gia dinh ve hanh trinh tim kiem vung dat ly tuong tren bau troi.',
      runtime: 105,
      posterUrl: 'https://picsum.photos/seed/doraemon-cinebooking/600/900',
      trailerUrl: 'https://www.youtube.com/',
      status: 'NOW_SHOWING',
      releaseDate: DateTime(2024, 6, 1),
    ),
    Movie(
      id: 'movie_endgame',
      title: 'Avengers: Endgame',
      description: 'Biet doi sieu anh hung Marvel trong tran chien lon nhat de cuu vu tru.',
      runtime: 181,
      posterUrl: 'https://picsum.photos/seed/endgame-cinebooking/600/900',
      trailerUrl: 'https://www.youtube.com/',
      status: 'NOW_SHOWING',
      releaseDate: DateTime(2019, 4, 26),
    ),
    Movie(
      id: 'movie_thienduongmau',
      title: 'Thien Duong Mau',
      description: 'Mot cau chuyen dien anh Viet voi nhieu mau sac cam xuc va kich tinh.',
      runtime: 118,
      posterUrl: 'https://picsum.photos/seed/thien-duong-mau/600/900',
      status: 'COMING_SOON',
      releaseDate: DateTime(2026, 7, 12),
    ),
  ];

  static final rooms = [
    const Room(id: 'room_1', roomName: 'Room 1', screenType: '2D'),
    const Room(id: 'room_2', roomName: 'Room 2', screenType: '3D'),
  ];

  static final showtimes = [
    Showtime(
      id: 'showtime_1',
      movieId: 'movie_doraemon',
      roomId: 'room_1',
      startTime: _nextAt(18),
      endTime: _nextAt(18).add(const Duration(minutes: 105)),
      basePrice: 80000,
      status: 'OPEN',
    ),
    Showtime(
      id: 'showtime_2',
      movieId: 'movie_doraemon',
      roomId: 'room_2',
      startTime: _nextAt(20),
      endTime: _nextAt(20).add(const Duration(minutes: 105)),
      basePrice: 95000,
      status: 'OPEN',
    ),
    Showtime(
      id: 'showtime_3',
      movieId: 'movie_endgame',
      roomId: 'room_2',
      startTime: _nextAt(19),
      endTime: _nextAt(19).add(const Duration(minutes: 181)),
      basePrice: 100000,
      status: 'OPEN',
    ),
  ];

  static final paymentMethods = [
    const PaymentMethod(code: 'MOMO', name: 'MoMo Wallet', isActive: true, sortOrder: 1),
    const PaymentMethod(code: 'VNPAY', name: 'VNPay Gateway', isActive: true, sortOrder: 2),
    const PaymentMethod(code: 'CASH', name: 'Cash', isActive: true, sortOrder: 3),
    const PaymentMethod(code: 'BANK', name: 'Bank Transfer', isActive: true, sortOrder: 4),
  ];

  static List<Seat> seatsForRoom(String roomId) {
    final rows = roomId == 'room_2' ? 3 : 4;
    const cols = 10;
    return [
      for (var r = 0; r < rows; r++)
        for (var c = 0; c < cols; c++)
          Seat(
            id: '${roomId}_${String.fromCharCode(65 + r)}${c + 1}',
            roomId: roomId,
            seatCode: '${String.fromCharCode(65 + r)}${c + 1}',
            seatType: r >= rows - 1 ? 'VIP' : 'STANDARD',
            rowIndex: r,
            colIndex: c,
          ),
    ];
  }

  static DateTime _nextAt(int hour) {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day + 1, hour);
  }
}
