import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'pages/about_page.dart';
import 'pages/admin/admin_dashboard_page.dart';
import 'pages/home_page.dart';
import 'pages/login_page.dart';
import 'pages/movie_list_page.dart';
import 'pages/register_page.dart';
import 'pages/ticket_history_page.dart';
import 'services/admin_service.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const CineBookingApp());
}

class CineBookingApp extends StatefulWidget {
  const CineBookingApp({super.key});

  @override
  State<CineBookingApp> createState() => _CineBookingAppState();
}

class _CineBookingAppState extends State<CineBookingApp> {
  ThemeMode _themeMode = ThemeMode.dark;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: _themeMode,
      title: 'CineBooking',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: AuthGate(
        onToggleTheme: _toggleTheme,
        themeMode: _themeMode,
      ),
      routes: {
        LoginPage.routeName: (_) => const LoginPage(),
        RegisterPage.routeName: (_) => const RegisterPage(),
        AdminDashboardPage.routeName: (_) => const AdminDashboardPage(),
        MovieListPage.routeName: (_) => const MovieListPage(),
        TicketHistoryPage.routeName: (_) => const TicketHistoryPage(),
        AboutPage.routeName: (_) => const AboutPage(),
      },
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({
    super.key,
    required this.onToggleTheme,
    required this.themeMode,
  });

  final VoidCallback onToggleTheme;
  final ThemeMode themeMode;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData) {
          return AppShell(
            onToggleTheme: onToggleTheme,
            themeMode: themeMode,
          );
        }

        return const LoginPage();
      },
    );
  }
}

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
        final pages = <Widget>[
          ..._basePages,
          if (isAdmin) const AdminDashboardPage(showAppBar: false),
        ];
        final titles = <String>[
          ..._baseTitles,
          if (isAdmin) 'Admin',
        ];
        final destinations = <NavigationDestination>[
          const NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          const NavigationDestination(
            icon: Icon(Icons.movie_outlined),
            selectedIcon: Icon(Icons.movie),
            label: 'Movies',
          ),
          const NavigationDestination(
            icon: Icon(Icons.confirmation_number_outlined),
            selectedIcon: Icon(Icons.confirmation_number),
            label: 'Lịch sử',
          ),
          const NavigationDestination(
            icon: Icon(Icons.info_outline),
            selectedIcon: Icon(Icons.info),
            label: 'About',
          ),
          if (isAdmin)
            const NavigationDestination(
              icon: Icon(Icons.admin_panel_settings_outlined),
              selectedIcon: Icon(Icons.admin_panel_settings),
              label: 'Admin',
            ),
        ];

        final safeIndex = _index >= pages.length ? pages.length - 1 : _index;
        if (safeIndex != _index) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) setState(() => _index = safeIndex);
          });
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(titles[safeIndex]),
            actions: [
              IconButton(
                tooltip: 'Sáng/Tối',
                icon: Icon(
                  widget.themeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode,
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
          body: IndexedStack(index: safeIndex, children: pages),
          bottomNavigationBar: NavigationBar(
            backgroundColor: scheme.surface,
            indicatorColor: scheme.primary,
            selectedIndex: safeIndex,
            onDestinationSelected: (value) => setState(() => _index = value),
            destinations: destinations,
          ),
        );
      },
    );
  }
}
