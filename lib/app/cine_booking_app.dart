import 'package:flutter/material.dart';

import '../pages/about_page.dart';
import '../pages/admin/admin_dashboard_page.dart';
import '../pages/login_page.dart';
import '../pages/movie_list_page.dart';
import '../pages/register_page.dart';
import '../pages/ticket_history_page.dart';
import '../theme/app_theme.dart';
import 'auth_gate.dart';

class CineBookingApp extends StatefulWidget {
  const CineBookingApp({super.key});

  @override
  State<CineBookingApp> createState() => _CineBookingAppState();
}

class _CineBookingAppState extends State<CineBookingApp> {
  ThemeMode _themeMode = ThemeMode.dark;

  void _toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.dark
              ? ThemeMode.light
              : ThemeMode.dark;
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
        AboutPage.routeName: (_) => AboutPage(
          onToggleTheme: _toggleTheme,
          themeMode: _themeMode,
        ),
      },
    );
  }
}