import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/admin_service.dart';
import '../widgets/app_background.dart';
import '../widgets/cinema_button.dart';
import '../widgets/section_title.dart';
import 'admin/admin_dashboard_page.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  static const routeName = '/about';

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final adminService = AdminService();
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: AppBackground(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            _ProfileCard(user: user),
            FutureBuilder<bool>(
              future: adminService.isCurrentUserAdmin(),
              builder: (context, snapshot) {
                if (snapshot.data != true) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(top: 14),
                  child: CinemaButton(
                    label: 'Admin Dashboard',
                    icon: Icons.admin_panel_settings,
                    expanded: true,
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const AdminDashboardPage()),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            const SectionTitle(title: 'CineBooking'),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: scheme.outline),
              ),
              child: const Column(
                children: [
                  _AboutRow(icon: Icons.cloud, title: 'Database', body: 'Firebase Cloud Firestore replaces MySQL/JPA repositories.'),
                  _AboutRow(icon: Icons.event_seat, title: 'Booking', body: 'Bookings start as PENDING and become PAID after payment confirmation.'),
                  _AboutRow(icon: Icons.confirmation_number, title: 'Tickets', body: 'Each selected seat receives an issued ticket code and QR content.'),
                  _AboutRow(icon: Icons.history, title: 'History', body: 'Ticket history is scoped to your authenticated Firebase account.'),
                ],
              ),
            ),
            const SizedBox(height: 18),
            CinemaButton(
              label: 'Đăng xuất',
              icon: Icons.logout,
              expanded: true,
              onPressed: () => FirebaseAuth.instance.signOut(),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.user});

  final User? user;

  @override
  Widget build(BuildContext context) {
    final name = user?.displayName ?? 'Cinema member';
    final email = user?.email ?? 'No email';
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(colors: [scheme.primaryContainer, scheme.surfaceContainerHighest]),
        border: Border.all(color: scheme.outline),
        boxShadow: [
          BoxShadow(color: scheme.shadow.withValues(alpha: 0.22), blurRadius: 24, offset: const Offset(0, 12)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(colors: [scheme.primary, scheme.secondary]),
              boxShadow: [BoxShadow(color: scheme.primary.withValues(alpha: 0.3), blurRadius: 20)],
            ),
            child: Icon(Icons.person, color: scheme.onPrimary, size: 34),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: scheme.onSurface, fontWeight: FontWeight.w900)),
                const SizedBox(height: 4),
                Text(email, style: TextStyle(color: scheme.onSurfaceVariant)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AboutRow extends StatelessWidget {
  const _AboutRow({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: scheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: scheme.onSurface, fontWeight: FontWeight.w900)),
                const SizedBox(height: 2),
                Text(body, style: TextStyle(color: scheme.onSurfaceVariant)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
