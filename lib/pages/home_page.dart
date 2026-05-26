import 'package:flutter/material.dart';

// Import dữ liệu phim
import '../data/movie_data.dart';

// Import header/footer dùng chung
import '../widgets/app_common.dart';

// ===============================
// TRANG HOME
// ===============================
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // ===============================
  // BANNER CHÍNH
  // ===============================
  // Banner hiển thị ảnh lớn đầu trang
  Widget buildBanner() {

    // LayoutBuilder giúp responsive
    return LayoutBuilder(
      builder: (context, constraints) {

        // Tính chiều cao banner theo width màn hình
        double bannerHeight =
            constraints.maxWidth * 0.28;

        // Giới hạn chiều cao tối thiểu
        if (bannerHeight < 150) {
          bannerHeight = 150;
        }

        // Giới hạn chiều cao tối đa
        if (bannerHeight > 280) {
          bannerHeight = 280;
        }

        return Container(

          // Margin xung quanh banner
          margin: const EdgeInsets.fromLTRB(
            36,
            36,
            36,
            24,
          ),

          child: ClipRRect(

            // Bo góc banner
            borderRadius:
                BorderRadius.circular(4),

            child: Stack(
              children: [

                // ===============================
                // ẢNH BANNER
                // ===============================
                Image.network(

                  // Link ảnh online
                  'https://images.unsplash.com/photo-1517602302552-471fe67acf66',

                  width: double.infinity,
                  height: bannerHeight,

                  // Ảnh phủ kín khung
                  fit: BoxFit.cover,
                ),

                // ===============================
                // LỚP OVERLAY TỐI
                // ===============================
                // Tạo lớp đen mờ để chữ nổi bật hơn
                Container(
                  width: double.infinity,
                  height: bannerHeight,

                  color: Colors.black.withOpacity(0.35),
                ),

                // ===============================
                // TEXT TRÊN BANNER
                // ===============================
                const Positioned(

                  // Vị trí chữ
                  left: 28,
                  bottom: 24,

                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: [

                      // Tiêu đề banner
                      Text(
                        'WEB CINE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 42,
                          fontWeight:
                              FontWeight.w800,
                        ),
                      ),

                      SizedBox(height: 8),

                      // Subtitle banner
                      Text(
                        'Movie Booking Management System',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

<<<<<<< HEAD
  Widget movieGrid() {
  return Padding(
    padding: const EdgeInsets.fromLTRB(36, 42, 36, 52),
    child: LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 700;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: movies.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isMobile ? 1 : 3,
            crossAxisSpacing: 28,
            mainAxisSpacing: 28,
            childAspectRatio: isMobile ? 1.6 : 0.9,
          ),
          itemBuilder: (context, index) {
            final movie = movies[index];

            return Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration( // bo góc - đổ bóng nền
                color: Colors.white,
                border: Border.all(color: AppCommon.borderColor),
                borderRadius: BorderRadius.circular(4),
              ),
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Image.network(
                      movie['posterUrl'],
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    movie['title'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    movie['description'],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 13),
                  ),
                ],
              ),
            );
          },
        );
      },
    ),
  );
}

 Widget buildIntro() {
=======
  // ===============================
  // GRID DANH SÁCH PHIM
  // ===============================
  Widget movieGrid() {

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        36,
        42,
        36,
        52,
      ),

      child: LayoutBuilder(

        // Responsive layout
        builder: (context, constraints) {

          // Nếu width nhỏ hơn 700 => mobile
          final isMobile =
              constraints.maxWidth < 700;

          return GridView.builder(

            // Grid nằm trong scroll cha
            shrinkWrap: true,

            // Tắt scroll riêng của GridView
            physics:
                const NeverScrollableScrollPhysics(),

            // Số lượng phim
            itemCount: movies.length,

            // ===============================
            // CẤU HÌNH GRID
            // ===============================
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(

              // Mobile 1 cột
              // Desktop 3 cột
              crossAxisCount:
                  isMobile ? 1 : 3,

              // Khoảng cách ngang
              crossAxisSpacing: 28,

              // Khoảng cách dọc
              mainAxisSpacing: 28,

              // Tỉ lệ card
              childAspectRatio:
                  isMobile ? 1.6 : 0.9,
            ),

            // ===============================
            // TẠO TỪNG ITEM
            // ===============================
            itemBuilder: (context, index) {

              // Lấy dữ liệu phim
              final movie = movies[index];

              return Container(

                // Padding bên trong card
                padding:
                    const EdgeInsets.all(14),

                decoration: BoxDecoration(
                  color: Colors.white,

                  // Viền card
                  border: Border.all(
                    color:
                        AppCommon.borderColor,
                  ),

                  // Bo góc card
                  borderRadius:
                      BorderRadius.circular(4),
                ),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    // ===============================
                    // ẢNH PHIM
                    // ===============================
                    Expanded(
                      child: Image.network(
                        movie.posterUrl,

                        width: double.infinity,

                        fit: BoxFit.cover,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // ===============================
                    // TÊN PHIM
                    // ===============================
                    Text(
                      movie.name,
                      style: const TextStyle(
                        fontWeight:
                            FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 6),

                    // ===============================
                    // MÔ TẢ PHIM
                    // ===============================
                    Text(
                      movie.description,

                      // Giới hạn 2 dòng
                      maxLines: 2,

                      // Quá dài hiện ...
                      overflow:
                          TextOverflow.ellipsis,

                      style: const TextStyle(
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  // ===============================
  // PHẦN GIỚI THIỆU
  // ===============================
  Widget buildIntro() {
>>>>>>> 13eba9893d6a23280c9f86bb2f6dcccced9d46c9
    return Container(
      width: double.infinity,

      // Padding section
      padding: const EdgeInsets.symmetric(
        vertical: 70,
        horizontal: 36,
      ),

      // Màu nền chung
      color: AppCommon.bgColor,

      child: const Column(
        children: [

          // Tiêu đề
          Text(
            'Home Web Cine',
            style: TextStyle(
              fontSize: 44,
              fontWeight: FontWeight.w800,
              color: Color(0xff222222),
            ),
          ),

          SizedBox(height: 10),

          // Mô tả
          Text(
            'Hệ thống quản lý thông tin phim, suất chiếu, đặt vé và người dùng.',

            // Căn giữa text
            textAlign: TextAlign.center,

            style: TextStyle(
              fontSize: 20,
              color: Color(0xff555555),
            ),
          ),
        ],
      ),
    );
  }

  // ===============================
  // BUILD GIAO DIỆN CHÍNH
  // ===============================
  @override
  Widget build(BuildContext context) {

    // Scroll toàn bộ trang
    return SingleChildScrollView(
<<<<<<< HEAD
      // cho phép cuộn khi nội dung vượt quá chiều cao
=======

>>>>>>> 13eba9893d6a23280c9f86bb2f6dcccced9d46c9
      child: Column(
        children: [

          // Header dùng chung
          AppCommon.header(),

          // Section giới thiệu
          buildIntro(),

          // Banner phim
          buildBanner(),

          // ===============================
          // TIÊU ĐỀ DANH SÁCH PHIM
          // ===============================
          const Padding(
            padding:
                EdgeInsets.symmetric(
              horizontal: 36,
            ),

            child: Align(

              // Căn trái
              alignment: Alignment.centerLeft,

              child: Text(
                'Phim nổi bật',

                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
<<<<<<< HEAD
          movieGrid(),
=======

          // Grid danh sách phim
          movieGrid(),

          // Footer dùng chung
>>>>>>> 13eba9893d6a23280c9f86bb2f6dcccced9d46c9
          AppCommon.footer(),
        ],
      ),
    );
  }
}