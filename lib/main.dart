import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // =====CÂU 1: KHAI BÁO BIẾN=====

    // Đối tượng: Phim
    int idPhim = 1;
    String tenPhim = "Avengers: Endgame";
    String theLoai = "Hành động";
    int thoiLuong = 181;
    double danhGia = 8.9;

    // Đối tượng: Người dùng
    int idNguoiDung = 101;
    String tenNguoiDung = "Nguyen Van A";
    String email = "nguyenvana@gmail.com";
    String vaiTro = "CUSTOMER";

    // Đối tượng: Đặt vé
    int idDatVe = 5001;
    String ngayDat = "20/04/2026";
    String gioChieu = "19:30";
    String soGhe = "A1";
    double giaVe = 90000;

    //=====CÂU 2: COLLECTIONS=====
    Map<String, dynamic> nguoiDung = {
      'idNguoiDung': idNguoiDung,
      'tenNguoiDung': tenNguoiDung,
      'email': email,
      'vaiTro': vaiTro,
    };

    List<Map<String, dynamic>> listPhim = [
      {
        'idPhim': 1,
        'tenPhim': 'Avengers: Endgame',
        'theLoai': 'Hành động',
        'thoiLuong': 181,
        'danhGia': 8.9,
      },
      {
        'idPhim': 2,
        'tenPhim': 'Dune Part Two',
        'theLoai': 'Khoa học viễn tưởng',
        'thoiLuong': 166,
        'danhGia': 8.7,
      },
      {
        'idPhim': 3,
        'tenPhim': 'Kung Fu Panda 4',
        'theLoai': 'Hoạt hình',
        'thoiLuong': 94,
        'danhGia': 7.5,
      },
    ];

    List<Map<String, dynamic>> listDatVe = [
      {
        'idDatVe': 5001,
        'ngayDat': '20/04/2026',
        'gioChieu': '19:30',
        'soGhe': 'A1',
        'giaVe': 90000,
      },
      {
        'idDatVe': 5002,
        'ngayDat': '20/04/2026',
        'gioChieu': '20:00',
        'soGhe': 'B2',
        'giaVe': 100000,
      },
      {
        'idDatVe': 5003,
        'ngayDat': '21/04/2026',
        'gioChieu': '18:00',
        'soGhe': 'C3',
        'giaVe': 85000,
      },
    ];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Bài thực hành số 2"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              // =========================
              // HIỂN THỊ CÂU 1
              const Text(
                "Câu 1: Sử dụng biến trong main.dart",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              const Text(
                "Thông tin phim",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text("ID phim: $idPhim"),
              Text("Tên phim: $tenPhim"),
              Text("Thể loại: $theLoai"),
              Text("Thời lượng: $thoiLuong phút"),
              Text("Đánh giá: $danhGia"),

              const SizedBox(height: 12),

              const Text(
                "Thông tin người dùng",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text("ID người dùng: $idNguoiDung"),
              Text("Tên người dùng: $tenNguoiDung"),
              Text("Email: $email"),
              Text("Vai trò: $vaiTro"),

              const SizedBox(height: 12),

              const Text(
                "Thông tin đặt vé",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text("ID đặt vé: $idDatVe"),
              Text("Ngày đặt: $ngayDat"),
              Text("Giờ chiếu: $gioChieu"),
              Text("Số ghế: $soGhe"),
              Text("Giá vé: $giaVe VNĐ"),

              const SizedBox(height: 24),

              // =========================
              // HIỂN THỊ CÂU 2
              const Text(
                "Câu 2: Collections trong main.dart",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              Text("Map người dùng: $nguoiDung"),
              const SizedBox(height: 8),
              Text("List phim: $listPhim"),
              const SizedBox(height: 8),
              Text("List đặt vé: $listDatVe"),

              const SizedBox(height: 24),

              // =========================
              // HIỂN THỊ CÂU 3

              const Text(
                "Câu 3: Hiển thị dữ liệu Collections trong Widget build",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              const Text(
                "Danh sách phim",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              ...listPhim.map(
                (phim) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(phim['tenPhim']),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(phim['theLoai']),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text("${phim['thoiLuong']} phút"),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                "Danh sách đặt vé",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              ...listDatVe.map(
                (datVe) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text("Mã: ${datVe['idDatVe']}"),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text("Ghế: ${datVe['soGhe']}"),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text("Giờ: ${datVe['gioChieu']}"),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text("${datVe['giaVe']} VNĐ"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}