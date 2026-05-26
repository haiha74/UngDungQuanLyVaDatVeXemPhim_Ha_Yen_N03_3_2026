import 'package:flutter/material.dart';
import '../data/movie_data.dart';
import '../widgets/app_common.dart';
<<<<<<< HEAD
import 'booking_form_page.dart';
=======
import 'package:cloud_firestore/cloud_firestore.dart';
>>>>>>> 13eba9893d6a23280c9f86bb2f6dcccced9d46c9

class ContentPage extends StatefulWidget {
  const ContentPage({super.key});

  @override
  State<ContentPage> createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController seatController = TextEditingController();

  String selectedMovie = movies[0].name;
  String customerName = '';
  String phone = '';
  String seat = '';

  Future<void> saveTicket() async {
    try {
      setState(() {
        customerName = nameController.text;
        phone = phoneController.text;
        seat = seatController.text;
      });

      await FirebaseFirestore.instance.collection('movies').add({
        'customerName': nameController.text,
        'phone': phoneController.text,
        'movie': selectedMovie,
        'seat': seatController.text,
        'createdAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã lưu thông tin mua vé lên Firebase')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi lưu Firebase: $e')),
      );
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    seatController.dispose();
    super.dispose();
  }

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
            'Movie Content & Ticket Booking',
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
          Expanded(child: _imageBox(movies[0].posterUrl)),
          const SizedBox(width: 32),
          Expanded(child: _imageBox(movies[1].posterUrl)),
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

<<<<<<< HEAD
  Widget movieList(BuildContext context) {
=======
  Widget ticketForm() {
    return Container(
      margin: const EdgeInsets.fromLTRB(36, 0, 36, 42),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppCommon.borderColor),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Form mua vé',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          const Text(
            'Nhập thông tin khách hàng và chọn phim muốn xem',
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 20),

          TextFormField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Họ tên khách hàng',
              hintText: 'Nguyen Van A',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 14),

          TextFormField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              labelText: 'Số điện thoại',
              hintText: '0987654321',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 14),

          DropdownButtonFormField<String>(
            value: selectedMovie,
            decoration: const InputDecoration(
              labelText: 'Chọn phim',
              border: OutlineInputBorder(),
            ),
            items: movies.map((movie) {
              return DropdownMenuItem<String>(
                value: movie.name,
                child: Text(movie.name),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedMovie = value!;
              });
            },
          ),

          const SizedBox(height: 14),

          TextFormField(
            controller: seatController,
            decoration: const InputDecoration(
              labelText: 'Ghế ngồi',
              hintText: 'Ví dụ: A1, B2, C3',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              onPressed: saveTicket,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
              ),
              child: const Text(
                'Lưu thông tin mua vé',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),

          const SizedBox(height: 22),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xfff4f4f4),
              border: Border.all(color: AppCommon.borderColor),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Thông tin vé vừa nhập:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text('Khách hàng: $customerName'),
                Text('Số điện thoại: $phone'),
                Text('Phim: $selectedMovie'),
                Text('Ghế: $seat'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget movieList() {
>>>>>>> 13eba9893d6a23280c9f86bb2f6dcccced9d46c9
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Movie List',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'Data from Web Cine',
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
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
                    movie.posterUrl,
                    width: 82,
                    height: 82,
                    fit: BoxFit.cover,
                  ),

                  const SizedBox(width: 18),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
<<<<<<< HEAD
                          movie['title'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),

=======
                          movie.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
>>>>>>> 13eba9893d6a23280c9f86bb2f6dcccced9d46c9
                        const SizedBox(height: 4),

                        Text(
                          movie.description,
                          style: const TextStyle(fontSize: 13, height: 1.3),
                        ),
<<<<<<< HEAD

                        const SizedBox(height: 10),

                        Row(
                          children: [
                            OutlinedButton(
                              onPressed: null,
                              child: Text('${movie['runtime']} phút'),
                            ),

                            const SizedBox(width: 12),

                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BookingFormPage(
                                      movieName: movie['title'],
                                    ),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 22,
                                  vertical: 12,
                                ),
                              ),
                              child: const Text('Mua vé'),
                            ),
                          ],
=======
                        const SizedBox(height: 8),
                        OutlinedButton(
                          onPressed: null,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [

                              Text('${movie.runtime} phút'),

                              Text(
                                movie.status,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),

                            ],
                          ),
>>>>>>> 13eba9893d6a23280c9f86bb2f6dcccced9d46c9
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

  Widget movieGrid(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: movies.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 18,
          mainAxisSpacing: 18,
          childAspectRatio: 1.75,
        ),
        itemBuilder: (context, index) {
          final movie = movies[index];

<<<<<<< HEAD
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: movies.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isMobile ? 1 : 3,
              crossAxisSpacing: 18,
              mainAxisSpacing: 18,
              childAspectRatio: isMobile ? 2.0 : 1.45,
=======
          return Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: AppCommon.borderColor),
              borderRadius: BorderRadius.circular(6),
>>>>>>> 13eba9893d6a23280c9f86bb2f6dcccced9d46c9
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 130,
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.network(
                      movie.posterUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
<<<<<<< HEAD
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: isMobile ? 120 : 120,
                      width: double.infinity,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.network(
                          movie['posterUrl'],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      movie['title'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      movie['description'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                    ),

                    const SizedBox(height: 10),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BookingFormPage(
                                 movieName: movie['title'],
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Mua vé'),
                      ),
                    ),
                  ],
=======
                const SizedBox(height: 8),
                Text(
                  movie.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
>>>>>>> 13eba9893d6a23280c9f86bb2f6dcccced9d46c9
                ),
                const SizedBox(height: 4),
                Text(
                  movie.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ],
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
<<<<<<< HEAD
          movieList(context),
          movieGrid(context),
=======
          movieList(),
          movieGrid(),
          ticketForm(),
>>>>>>> 13eba9893d6a23280c9f86bb2f6dcccced9d46c9
          AppCommon.footer(),
        ],
      ),
    );
  }
}