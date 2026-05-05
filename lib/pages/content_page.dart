import 'package:flutter/material.dart';
import '../data/movie_data.dart';
import '../widgets/app_common.dart';

class ContentPage extends StatelessWidget {
  const ContentPage({super.key});

  Widget hero() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 76),
      color: AppCommon.bgColor,
      child: const Column(
        children: [
          Text(
            'Web Cine',
            style: TextStyle(
              fontSize: 44,
              fontWeight: FontWeight.w800,
              color: Color(0xff222222),
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Movie Content',
            style: TextStyle(fontSize: 20, color: Color(0xff555555)),
          ),
        ],
      ),
    );
  }

  Widget imagePanel() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(36, 36, 36, 48),
      child: Row(
        children: [
          Expanded(child: _imageBox(movies[0]['posterUrl'])),
          const SizedBox(width: 32),
          Expanded(child: _imageBox(movies[1]['posterUrl'])),
        ],
      ),
    );
  }

  Widget _imageBox(String url) {
    return Container(
      height: 220,
      color: const Color(0xffe9e9e9),
      child: Image.network(url, fit: BoxFit.cover),
    );
  }

  Widget movieList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Movie List',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text('Data from Web Cine',
              style: TextStyle(fontSize: 13, color: Colors.grey)),
          const SizedBox(height: 22),
          ...movies.map((movie) {
            return Container(
              margin: const EdgeInsets.only(bottom: 18),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: AppCommon.borderColor),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  Image.network(
                    movie['posterUrl'],
                    width: 82,
                    height: 82,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(movie['title'],
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(
                          movie['description'],
                          style: const TextStyle(fontSize: 13, height: 1.3),
                        ),
                        const SizedBox(height: 8),
                        OutlinedButton(
                          onPressed: null,
                          child: Text('${movie['runtime']} phút'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
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
                decoration: BoxDecoration(
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          AppCommon.header(),
          hero(),
          imagePanel(),
          movieList(),
          movieGrid(),
          AppCommon.footer(),
        ],
      ),
    );
  }
}