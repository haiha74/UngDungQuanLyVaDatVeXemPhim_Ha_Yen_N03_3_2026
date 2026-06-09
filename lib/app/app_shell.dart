import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../pages/about_page.dart';
import '../pages/admin/admin_dashboard_page.dart';
import '../pages/home_page.dart';
import '../pages/movie_list_page.dart';
import '../pages/ticket_history_page.dart';
import '../services/admin_service.dart';

class AppShell extends StatefulWidget {
  const AppShell({
    super.key,
    required this.onToggleTheme,
    required this.themeMode,
  });

  final VoidCallback onToggleTheme;
  final ThemeMode themeMode;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  final _adminService = AdminService();
  int _index = 0;
  late Future<bool> _isAdmin;

  static const _basePages = [
    HomePage(),
    MovieListPage(),
    TicketHistoryPage(),
    AboutPage(),
  ];

  static const _baseTitles = [
    'CineBooking',
    'Movies',
    'Lịch sử',
    'About',
  ];

  @override
  void initState() {
    super.initState();
    _isAdmin = _loadAdminAccess();
  }

  Future<bool> _loadAdminAccess() async {
    final role = await _adminService.getCurrentUserRole();
    final uid = FirebaseAuth.instance.currentUser?.uid;
    debugPrint('[AppShell] current uid=$uid, role=$role');
    return role == 'ADMIN';
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return FutureBuilder<bool>(
      future: _isAdmin,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final isAdmin = snapshot.data == true;

        if (isAdmin) {
          return const AdminDashboardPage(showAppBar: true);
        }

        final pages = <Widget>[
          ..._basePages,
        ];

        final titles = <String>[
          ..._baseTitles,
        ];

        const destinations = <NavigationDestination>[
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.movie_outlined),
            selectedIcon: Icon(Icons.movie),
            label: 'Movies',
          ),
          NavigationDestination(
            icon: Icon(Icons.confirmation_number_outlined),
            selectedIcon: Icon(Icons.confirmation_number),
            label: 'Lịch sử',
          ),
          NavigationDestination(
            icon: Icon(Icons.info_outline),
            selectedIcon: Icon(Icons.info),
            label: 'About',
          ),
        ];

        final safeIndex = _index >= pages.length ? pages.length - 1 : _index;

        return Scaffold(
          appBar: AppBar(
            title: Text(titles[safeIndex]),
            actions: [
              IconButton(
                tooltip: 'Sáng/Tối',
                icon: Icon(
                  widget.themeMode == ThemeMode.dark
                      ? Icons.light_mode
                      : Icons.dark_mode,
                ),
                onPressed: widget.onToggleTheme,
              ),
              IconButton(
                onPressed: () => FirebaseAuth.instance.signOut(),
                icon: const Icon(Icons.logout),
                tooltip: 'Đăng xuất',
              ),
            ],
          ),
          body: IndexedStack(
            index: safeIndex,
            children: pages,
          ),
          bottomNavigationBar: NavigationBar(
            backgroundColor: scheme.surface,
            indicatorColor: scheme.primary,
            selectedIndex: safeIndex,
            onDestinationSelected: (value) {
              setState(() {
                _index = value;
              });
            },
            destinations: destinations,
          ),
        );
      },
    );
  }
}