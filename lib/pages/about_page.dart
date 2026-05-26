import 'package:flutter/material.dart';

// Import header/footer dùng chung
import '../widgets/app_common.dart';

// ===============================
// TRANG ABOUT
// ===============================
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  // ===============================
  // HERO + FORM SECTION
  // ===============================
  // Phần banner chính chứa form thông tin
  Widget heroForm() {
    return Container(
      width: double.infinity,

      // Khoảng cách trên dưới
      padding: const EdgeInsets.symmetric(vertical: 70),

      // Màu nền chung
      color: AppCommon.bgColor,

      child: Center(
        child: SizedBox(

          // Giới hạn chiều rộng form
          width: 360,

          child: Column(
            children: [

              // Tiêu đề lớn
              const Text(
                'About Web Cine',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w800,
                  color: Color(0xff222222),
                ),
              ),

              const SizedBox(height: 10),

              // Subtitle
              const Text(
                'Project Information',
                style: TextStyle(
                  fontSize: 22,
                  color: Color(0xff333333),
                ),
              ),

              const SizedBox(height: 30),

              // ===============================
              // FORM BOX
              // ===============================
              Container(
                width: double.infinity,

                // Padding bên trong form
                padding: const EdgeInsets.fromLTRB(
                  24,
                  24,
                  24,
                  24,
                ),

                decoration: BoxDecoration(
                  color: Colors.white,

                  // Viền form
                  border: Border.all(
                    color: const Color(0xffd8d8d8),
                  ),

                  // Bo góc form
                  borderRadius: BorderRadius.circular(8),
                ),

                child: Column(
                  children: [

                    // Input tên project
                    const _Input(
                      label: 'Project Name',
                      hint: 'Web Cine',
                    ),

                    const SizedBox(height: 22),

                    // Input tên sinh viên
                    const _Input(
                      label: 'Student Name',
                      hint:
                          'Nguyen Hai Ha - Vu Thi Hai Yen',
                    ),

                    const SizedBox(height: 22),

                    // Input trường học
                    const _Input(
                      label: 'University',
                      hint: 'Phenikaa University',
                    ),

                    const SizedBox(height: 22),

                    // Input message nhiều dòng
                    const _Input(
                      label: 'Message',
                      hint: 'Flutter App',

                      // Cho phép nhập nhiều dòng
                      maxLines: 4,
                    ),

                    const SizedBox(height: 24),

                    // ===============================
                    // BUTTON SUBMIT
                    // ===============================
                    Container(
                      width: double.infinity,
                      height: 46,

                      // Căn giữa chữ
                      alignment: Alignment.center,

                      decoration: BoxDecoration(

                        // Màu nền button
                        color: const Color(0xff2b2b2b),

                        // Bo góc button
                        borderRadius:
                            BorderRadius.circular(6),
                      ),

                      child: const Text(
                        'Submit',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
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

  // ===============================
  // PHẦN THÔNG TIN DỰ ÁN
  // ===============================
  Widget aboutContent() {
    return Padding(
      padding: const EdgeInsets.all(36),

      child: Column(
        children: [

          // Thông tin project
          _infoRow(
            'Project',
            'Web Cine - Quản lý rạp chiếu phim',
          ),

          // Công nghệ sử dụng
          _infoRow(
            'Technology',
            'Flutter App',
          ),

          // Các đối tượng chính
          _infoRow(
            'Main Object',
            'Movie, Showtime, Booking, Payment, User',
          ),

          // Thành viên nhóm
          _infoRow(
            'Student',
            'Nguyen Hai Ha - Vu Thi Hai Yen',
          ),
        ],
      ),
    );
  }

  // ===============================
  // ITEM HIỂN THỊ THÔNG TIN
  // ===============================
  Widget _infoRow(String title, String content) {
    return Container(

      // Khoảng cách dưới mỗi item
      margin: const EdgeInsets.only(bottom: 14),

      // Padding bên trong item
      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: Colors.white,

        // Viền item
        border: Border.all(
          color: AppCommon.borderColor,
        ),

        // Bo góc item
        borderRadius: BorderRadius.circular(4),
      ),

      child: Row(
        children: [

          // Icon thông tin
          const Icon(
            Icons.info_outline,
            size: 26,
          ),

          const SizedBox(width: 16),

          // Nội dung text
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                // Tiêu đề
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                // Nội dung
                Text(content),
              ],
            ),
          )
        ],
      ),
    );
  }

  // ===============================
  // BUILD UI CHÍNH
  // ===============================
  @override
  Widget build(BuildContext context) {

    // SingleChildScrollView giúp cuộn trang
    return SingleChildScrollView(

      child: Column(
        children: [

          // Header dùng chung
          AppCommon.header(),

          // Hero + Form
          heroForm(),

          // Footer dùng chung
          AppCommon.footer(),
        ],
      ),
    );
  }
}

// ===============================
// WIDGET INPUT CUSTOM
// ===============================
class _Input extends StatelessWidget {

  // Label phía trên input
  final String label;

  // Placeholder trong input
  final String hint;

  // Số dòng của input
  final int maxLines;

  const _Input({
    required this.label,
    required this.hint,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(

      // Căn trái
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [

        // Label
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xff222222),
          ),
        ),

        const SizedBox(height: 8),

        // Ô nhập liệu
        TextField(

          // Cho phép nhiều dòng
          maxLines: maxLines,

          decoration: InputDecoration(

            // Placeholder
            hintText: hint,

            // Style placeholder
            hintStyle: const TextStyle(
              color: Color(0xffb5b5b5),
            ),

            // Padding bên trong input
            contentPadding:
                const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),

            // Border khi chưa focus
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Color(0xffd8d8d8),
              ),

              borderRadius:
                  BorderRadius.circular(8),
            ),

            // Border khi click vào input
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Color(0xff999999),
              ),

              borderRadius:
                  BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }
}