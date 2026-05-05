import 'package:flutter/material.dart';
import '../widgets/app_common.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  Widget heroForm() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 70),
      color: AppCommon.bgColor,
      child: Center(
        child: SizedBox(
          width: 360,
          child: Column(
            children: [
              const Text(
                'About Web Cine',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w800,
                  color: Color(0xff222222),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Project Information',
                style: TextStyle(fontSize: 22, color: Color(0xff333333)),
              ),
              const SizedBox(height: 30),

              // KHUNG FORM GIỐNG ẢNH
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xffd8d8d8)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    const _Input(label: 'Project Name', hint: 'Web Cine'),
                    const SizedBox(height: 22),
                    const _Input(label: 'Student Name', hint: 'Nguyen Hai Ha - Vu Thi Hai Yen'),
                    const SizedBox(height: 22),
                    const _Input(label: 'University', hint: 'Phenikaa University'),
                    const SizedBox(height: 22),
                    const _Input(
                      label: 'Message',
                      hint: 'Flutter App',
                      maxLines: 4,
                    ),
                    const SizedBox(height: 24),

                    // BUTTON NẰM TRONG KHUNG
                    Container(
                      width: double.infinity,
                      height: 46,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xff2b2b2b),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'Submit',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
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

  Widget aboutContent() {
    return Padding(
      padding: const EdgeInsets.all(36),
      child: Column(
        children: [
          _infoRow('Project', 'Web Cine - Quản lý rạp chiếu phim'),
          _infoRow('Technology', 'Flutter App'),
          _infoRow('Main Object', 'Movie, Showtime, Booking, Payment, User'),
          _infoRow('Student', 'Nguyen Hai Ha - Vu Thi Hai Yen'),
        ],
      ),
    );
  }

  Widget _infoRow(String title, String content) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppCommon.borderColor),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, size: 26),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(content),
              ],
            ),
          )
        ],
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

          AppCommon.footer(),
        ],
      ),
    );
  }
}

class _Input extends StatelessWidget {
  final String label;
  final String hint;
  final int maxLines;

  const _Input({
    required this.label,
    required this.hint,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xff222222),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xffb5b5b5)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xffd8d8d8)),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xff999999)),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }
}