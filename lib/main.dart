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

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const CineBookingApp());
}

class CineBookingApp extends StatelessWidget {
  const CineBookingApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFFE5383B),
      brightness: Brightness.dark,
    );

    return MaterialApp(
      title: 'CineBooking',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: colorScheme,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF07070A),
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          centerTitle: false,
          backgroundColor: Color(0xFF0D0D10),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          color: const Color(0xFF17171B),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF18181D),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFF303038)),
          ),
        ),
      ),
      home: const AuthGate(),
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
  const AuthGate({super.key});

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
          return const AppShell();
        }

        return const LoginPage();
      },
    );
  }
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});

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
                onPressed: () => FirebaseAuth.instance.signOut(),
                icon: const Icon(Icons.logout),
                tooltip: 'Đăng xuất',
              ),
            ],
          ),
          body: IndexedStack(index: safeIndex, children: pages),
          bottomNavigationBar: NavigationBar(
            backgroundColor: const Color(0xFF101014),
            indicatorColor: const Color(0xFFE5383B),
            selectedIndex: safeIndex,
            onDestinationSelected: (value) => setState(() => _index = value),
            destinations: destinations,
          ),
        );
      },
    );
  }
}
