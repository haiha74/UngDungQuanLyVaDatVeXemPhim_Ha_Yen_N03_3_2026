import 'package:flutter/material.dart';

class AppCommon {
  static Widget header() {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color(0xffeeeeee)),
        ),
      ),
      child: Row(
        children: [
          Image.network(
            'https://lethunguyen.github.io/MobileDev/demo/logo.png',
            height: 28,
          ),
          const Spacer(),
          const Text('Products'),
          const SizedBox(width: 18),
          const Text('Solutions'),
          const SizedBox(width: 18),
          const Text('Community'),
          const SizedBox(width: 18),
          const Text('Resources'),
          const SizedBox(width: 18),
          const Text('Pricing'),
          const SizedBox(width: 18),
          const Text('Contact'),
          const SizedBox(width: 18),
          OutlinedButton(
            onPressed: null,
            child: Text('Sign in'),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: null,
            style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(Colors.black),
            ),
            child: Text('Register'),
          ),
        ],
      ),
    );
  }

  static Widget footer() {
    return Container(
      padding: const EdgeInsets.all(32),
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 180,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Icon(Icons.movie_filter, size: 30),
                SizedBox(height: 18),
                Text('✕   ◎   ▶   in'),
              ],
            ),
          ),
          Expanded(
            child: _footerColumn(
              'Use cases',
              [
                'Movie management',
                'Showtime booking',
                'Ticket selling',
                'Seat selection',
                'Payment tracking',
                'User management',
              ],
            ),
          ),
          Expanded(
            child: _footerColumn(
              'Explore',
              [
                'Movies',
                'Rooms',
                'Seats',
                'Bookings',
                'Payments',
                'Tickets',
              ],
            ),
          ),
          Expanded(
            child: _footerColumn(
              'Resources',
              [
                'Web Cine',
                'Flutter App',
                'Java Web',
                'Phenikaa University',
                'Nguyen Hai Ha',
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _footerColumn(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 14),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(item),
          ),
        ),
      ],
    );
  }
}