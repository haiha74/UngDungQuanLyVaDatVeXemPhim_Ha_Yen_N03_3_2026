import 'package:flutter/material.dart';
import '../data/movie_data.dart';
import '../widgets/app_common.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Widget buildBanner() {
    return LayoutBuilder(
      builder: (context, constraints) {
        double bannerHeight = constraints.maxWidth * 0.28;

        if (bannerHeight < 150) bannerHeight = 150;
        if (bannerHeight > 280) bannerHeight = 280;

        return Container(
          margin: const EdgeInsets.fromLTRB(36, 36, 36, 24),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Stack(
              children: [
                Image.network(
                  'https://images.unsplash.com/photo-1517602302552-471fe67acf66',
                  width: double.infinity,
                  height: bannerHeight,
                  fit: BoxFit.cover,
                ),
                Container(
                  width: double.infinity,
                  height: bannerHeight,
                  color: Colors.black.withOpacity(0.35),
                ),
                const Positioned(
                  left: 28,
                  bottom: 24,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'WEB CINE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 42,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Movie Booking Management System',
                        style: TextStyle(color: Colors.white, fontSize: 18),
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 70, horizontal: 36),
      color: AppCommon.bgColor,
      child: const Column(
        children: [
          Text(
            'Home Web Cine',
            style: TextStyle(
              fontSize: 44,
              fontWeight: FontWeight.w800,
              color: Color(0xff222222),
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Hệ thống quản lý thông tin phim, suất chiếu, đặt vé và người dùng.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, color: Color(0xff555555)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // cho phép cuộn khi nội dung vượt quá chiều cao
      child: Column(
        children: [
          AppCommon.header(),
          buildIntro(),
          buildBanner(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 36),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Phim nổi bật',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          movieGrid(),
          AppCommon.footer(),
        ],
      ),
    );
  }
}