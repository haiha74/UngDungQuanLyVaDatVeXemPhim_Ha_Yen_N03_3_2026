import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Widget buildHeader() {
    return LayoutBuilder(
      builder: (context, constraints) {
        double bannerHeight = constraints.maxWidth * 0.28;

        if (bannerHeight < 140) {
          bannerHeight = 140;
        }

        if (bannerHeight > 260) {
          bannerHeight = 260;
        }

        return ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          child: Image.network(
            "https://img.pikbest.com/templates/20240805/cinema-text-style-effect-3d-realistic-template-on-dark-background_10700963.jpg!bw700",
            width: double.infinity,
            height: bannerHeight,
            fit: BoxFit.cover,
          ),
        );
      },
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
        const SizedBox(height: 20),
        const Expanded(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              "Chào mừng bạn đến với rạp chiếu phim ",
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
        buildFooter(),
      ],
    );
  }
}