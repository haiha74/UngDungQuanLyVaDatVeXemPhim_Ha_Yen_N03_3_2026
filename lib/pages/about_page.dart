import 'package:flutter/material.dart';
import '../widgets/app_common.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  Widget heroForm() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 70),
      color: const Color(0xfff2f2f2),
      child: Center(
        child: SizedBox(
          width: 360,
          child: Column(
            children: [
              const Text(
                'About Web Cine',
                style: TextStyle(fontSize: 38, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text('Project information'),
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    children: const [
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Project Name',
                          hintText: 'Web Cine',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 12),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Student Name',
                          hintText: 'Nguyen Hai Ha',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 12),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'University',
                          hintText: 'Phenikaa University',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 12),
                      TextField(
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: 'Message',
                          hintText: 'Java Web chuyển sang Flutter App',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: null,
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.black),
                  ),
                  child: Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget aboutContent() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          _infoRow('Project', 'Web Cine - Quản lý rạp chiếu phim'),
          _infoRow('Technology', 'Java Web chuyển dần sang Flutter App'),
          _infoRow('Main Object', 'Movie, Showtime, Booking, Payment, User'),
          _infoRow('Student', 'Nguyen Hai Ha'),
        ],
      ),
    );
  }

  Widget _infoRow(String title, String content) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: ListTile(
        leading: const Icon(Icons.info_outline),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(content),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          AppCommon.header(),
          heroForm(),
          aboutContent(),
          AppCommon.footer(),
        ],
      ),
    );
  }
}