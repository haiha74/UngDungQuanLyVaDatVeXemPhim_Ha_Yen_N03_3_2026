import 'package:flutter/material.dart';

class BookingFormPage extends StatefulWidget {

  // NHẬN TÊN PHIM TỪ CONTENT PAGE
  final String movieName;

  const BookingFormPage({
    super.key,
    required this.movieName,
  });

  @override
  State<BookingFormPage> createState() => _BookingFormPageState();
}

class _BookingFormPageState extends State<BookingFormPage> {

  // DỮ LIỆU NGƯỜI DÙNG NHẬP
  String customerName = '';
  String phone = '';
  String ticketType = 'Vé thường';

  // TEXTFIELD
  void handleNameChanged(String value) {
    setState(() {
      customerName = value;
    });
  }

  // TEXTFIELD
  void handlePhoneChanged(String value) {
    setState(() {
      phone = value;
    });
  }

  // DROPDOWN
  void handleTicketTypeChanged(String? value) {
    if (value != null) {
      setState(() {
        ticketType = value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xfff8eef8),

      appBar: AppBar(
        title: const Text('Mua vé'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: 420,
            margin: const EdgeInsets.all(24),
            padding: const EdgeInsets.all(24),

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.black12),
            ),

            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                // TÊN PHIM
                Text(
                  widget.movieName,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 24),

                // TEXTFORMFIELD
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Tên khách hàng',
                    hintText: 'Nhập tên của bạn',
                    border: OutlineInputBorder(),
                  ),

                  onChanged: handleNameChanged,
                ),

                const SizedBox(height: 16),

                // TEXTFORMFIELD
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Số điện thoại',
                    hintText: 'Nhập số điện thoại',
                    border: OutlineInputBorder(),
                  ),

                  onChanged: handlePhoneChanged,
                ),

                const SizedBox(height: 16),

                // DROPDOWN
                DropdownButtonFormField<String>(
                  value: ticketType,

                  decoration: const InputDecoration(
                    labelText: 'Loại vé',
                    border: OutlineInputBorder(),
                  ),

                  items: const [

                    DropdownMenuItem(
                      value: 'Vé thường',
                      child: Text('Vé thường'),
                    ),

                    DropdownMenuItem(
                      value: 'Vé VIP',
                      child: Text('Vé VIP'),
                    ),

                    DropdownMenuItem(
                      value: 'Vé đôi',
                      child: Text('Vé đôi'),
                    ),
                  ],

                  onChanged: handleTicketTypeChanged,
                ),

                const SizedBox(height: 24),

                // HIỂN THỊ DỮ LIỆU
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),

                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.deepPurple),
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      const Text(
                        'Thông tin đặt vé:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text('Phim: ${widget.movieName}'),

                      const SizedBox(height: 6),

                      Text('Tên khách hàng: $customerName'),

                      const SizedBox(height: 6),

                      Text('Số điện thoại: $phone'),

                      const SizedBox(height: 6),

                      Text('Loại vé: $ticketType'),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,

                  child: ElevatedButton(
                    onPressed: () {

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Đặt vé thành công'),
                        ),
                      );
                    },

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),

                    child: const Text('Xác nhận đặt vé'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}