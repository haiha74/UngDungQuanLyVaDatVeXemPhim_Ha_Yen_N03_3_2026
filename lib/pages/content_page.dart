import 'package:flutter/material.dart';

class ContentPage extends StatelessWidget {
  const ContentPage({super.key});

  final List<Map<String, dynamic>> movies = const [
    {
      'movieId': 1,
      'title': 'Avengers: Endgame',
      'description': 'Phim siêu anh hùng Marvel',
      'runtime': 181,
      'status': 'NOW_SHOWING',
    },
    {
      'movieId': 2,
      'title': 'Dune Part Two',
      'description': 'Phim khoa học viễn tưởng',
      'runtime': 166,
      'status': 'COMING_SOON',
    },
    {
      'movieId': 3,
      'title': 'Kung Fu Panda 4',
      'description': 'Phim hoạt hình',
      'runtime': 94,
      'status': 'NOW_SHOWING',
    },
  ];

  Widget buildHeader() {
    return Container(
      height: 140,
      width: double.infinity,
      color: Colors.blueGrey,
      child: const Icon(
        Icons.movie,
        size: 80,
        color: Colors.white,
      ),
    );
  }

  Widget buildFooter() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      color: Colors.blueGrey,
      child: const Text(
        "Phenikaa University - Nguyen Hai Ha - Vu Thi Hai Yen",
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildHeader(),
        const SizedBox(height: 10),
        const Text(
          "CONTENT - Danh sách phim",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];

              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  leading: const Icon(Icons.movie),
                  title: Text(movie['title']),
                  subtitle: Text(
                    "ID: ${movie['movieId']}\n"
                    "Mô tả: ${movie['description']}\n"
                    "Thời lượng: ${movie['runtime']} phút\n"
                    "Trạng thái: ${movie['status']}",
                  ),
                ),
              );
            },
          ),
        ),
        buildFooter(),
      ],
    );
  }
}