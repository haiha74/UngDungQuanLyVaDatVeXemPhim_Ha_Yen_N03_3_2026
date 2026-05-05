import 'package:flutter/material.dart';
import '../data/movie_data.dart';
import '../widgets/app_common.dart';

class ContentPage extends StatelessWidget {
  const ContentPage({super.key});

  Widget hero() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 70),
      color: const Color(0xfff2f2f2),
      child: const Column(
        children: [
          Text(
            'Web Cine Content',
            style: TextStyle(fontSize: 38, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text('Movie list from Web Cine project'),
        ],
      ),
    );
  }

  Widget imagePanel() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Row(
        children: [
          Expanded(child: _bigImage(movies[0]['posterUrl'])),
          const SizedBox(width: 28),
          Expanded(child: _bigImage(movies[1]['posterUrl'])),
        ],
      ),
    );
  }

  Widget _bigImage(String url) {
    return Container(
      height: 180,
      color: const Color(0xffeeeeee),
      child: Image.network(url, fit: BoxFit.cover),
    );
  }

  Widget movieList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Movie List', style: TextStyle(fontWeight: FontWeight.bold)),
          const Text('Data from Web Cine'),
          const SizedBox(height: 16),
          ...movies.map(
            (movie) => Card(
              margin: const EdgeInsets.only(bottom: 14),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    Image.network(
                      movie['posterUrl'],
                      width: 90,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            movie['title'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(movie['description']),
                          const SizedBox(height: 6),
                          OutlinedButton(
                            onPressed: null,
                            child: Text('${movie['runtime']} phút'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget movieGrid() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: movies.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          childAspectRatio: 0.9,
        ),
        itemBuilder: (context, index) {
          final movie = movies[index];

          return Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    movie['posterUrl'],
                    height: 90,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    movie['title'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    movie['description'],
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
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