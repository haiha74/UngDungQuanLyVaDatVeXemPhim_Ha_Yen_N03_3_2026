import 'package:flutter/material.dart';

class AppCommon {
  static const Color bgColor = Color(0xfff4f4f4);
  static const Color borderColor = Color(0xffdddddd);
  static const Color textColor = Color(0xff222222);

  static Widget header() {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: borderColor)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 760;

          if (isMobile) {
            return Row(
              children: [
                Image.network(
                  'https://lethunguyen.github.io/MobileDev/demo/logo.png',
                  height: 24,
                ),
                const Spacer(),

                PopupMenuButton<String>(
                  icon: const Icon(Icons.menu),
                  onSelected: (value) {},
                  itemBuilder: (context) => const [
                    PopupMenuItem(value: 'products', child: Text('Products')),
                    PopupMenuItem(value: 'solutions', child: Text('Solutions')),
                    PopupMenuItem(value: 'community', child: Text('Community')),
                    PopupMenuItem(value: 'resources', child: Text('Resources')),
                    PopupMenuItem(value: 'pricing', child: Text('Pricing')),
                    PopupMenuItem(value: 'contact', child: Text('Contact')),
                    PopupMenuDivider(),
                    PopupMenuItem(value: 'signin', child: Text('Sign in')),
                    PopupMenuItem(value: 'register', child: Text('Register')),
                  ],
                ),
              ],
            );
          }

          return Row(
            children: [
              Image.network(
                'https://lethunguyen.github.io/MobileDev/demo/logo.png',
                height: 24,
              ),
              const Spacer(),
              _navText('Products'),
              _navText('Solutions'),
              _navText('Community'),
              _navText('Resources'),
              _navText('Pricing'),
              _navText('Contact'),
              const SizedBox(width: 16),
              _smallButton('Sign in', false),
              const SizedBox(width: 8),
              _smallButton('Register', true),
            ],
          );
        },
      ),
    );
  }

  static Widget _navText(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 6),
      child: TextButton(
        onPressed: () {},
        style: ButtonStyle(
          foregroundColor: const WidgetStatePropertyAll(Colors.black),
          overlayColor: WidgetStatePropertyAll(Colors.grey.shade200),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 14, vertical: 18),
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          ),
        ),
        child: Text(text, style: const TextStyle(fontSize: 13)),
      ),
    );
  }

  static Widget _smallButton(String text, bool dark) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(4),
      hoverColor: Colors.grey.shade300,
      child: Container(
        height: 34,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: dark ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.black),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: dark ? Colors.white : Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  static Widget footer() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 36),
      color: Colors.white,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 700;

          return Wrap(
            spacing: 70,
            runSpacing: 28,
            children: [
              SizedBox(
                width: isMobile ? double.infinity : 180,
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.movie_filter, size: 32),
                    SizedBox(height: 18),
                    Text('✕   ◎   ▶   in', style: TextStyle(fontSize: 18)),
                  ],
                ),
              ),
              _footerColumn('Use cases', [
                'Movie management',
                'Showtime booking',
                'Ticket selling',
                'Seat selection',
                'Payment tracking',
                'User management',
              ], isMobile),
              _footerColumn('Explore', [
                'Movies',
                'Rooms',
                'Seats',
                'Bookings',
                'Payments',
                'Tickets',
              ], isMobile),
              _footerColumn('Resources', [
                'Web Cine',
                'Flutter App',
                'Java Web',
                'Phenikaa University',
                'Nguyen Hai Ha - Vu Thi Hai Yen',
              ], isMobile),
            ],
          );
        },
      ),
    );
  }

  static Widget _footerColumn(
    String title,
    List<String> items,
    bool isMobile,
  ) {
    return SizedBox(
      width: isMobile ? double.infinity : 170,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
          const SizedBox(height: 18),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                item,
                style: const TextStyle(
                  fontSize: 13,
                  color: textColor,
                  height: 1.3,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}