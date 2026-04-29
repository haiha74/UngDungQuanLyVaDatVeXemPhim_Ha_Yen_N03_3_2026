import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  Widget buildHeader() {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 150,
            child: Image.network(
              "https://lethunguyen.github.io/MobileDev/demo/logo.png",
            ),
          ),

          const CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage(
              "https://i.ibb.co/m5S4w28T/Beauty-Plus-Collage-2026-04-29-T03-21-20.png",
            ),
          ),
        ],
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
        const SizedBox(height: 20),
        const Expanded(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              "ABOUT\n\n"
              "Bài thực hành tuần 4\n\n"
              "Project: Web Cine - Quản lý rạp chiếu phim\n"
              "Sinh viên: Nguyen Hai Ha - Vu Thi Hai Yen\n"
              "Trường: Phenikaa University\n\n"
              "Ứng dụng gồm 3 màn hình: Home, Content và About. "
              "Mỗi màn hình sử dụng Column Layout và điều hướng bằng Bottom Navigation Bar.",
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
        buildFooter(),
      ],
    );
  }
}