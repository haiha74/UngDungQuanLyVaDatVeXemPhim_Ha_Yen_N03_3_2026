import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  static const routeName = '/login';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
    } on FirebaseAuthException catch (error) {
      _showError(_authMessage(error));
    } catch (error) {
      _showError('Login failed: $error');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Icon(Icons.local_movies, size: 52, color: Theme.of(context).colorScheme.primary),
                        const SizedBox(height: 12),
                        Text(
                          'CineBooking',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.mail_outline),
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            final text = value?.trim() ?? '';
                            return text.contains('@') ? null : 'Enter a valid email';
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: const Icon(Icons.lock_outline),
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                              icon: Icon(_obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                              tooltip: _obscurePassword ? 'Show password' : 'Hide password',
                            ),
                          ),
                          obscureText: _obscurePassword,
                          validator: (value) => (value?.length ?? 0) >= 6 ? null : 'Password must be at least 6 characters',
                        ),
                        const SizedBox(height: 18),
                        FilledButton.icon(
                          onPressed: _loading ? null : _login,
                          icon: _loading
                              ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                              : const Icon(Icons.login),
                          label: const Text('Login'),
                        ),
                        const SizedBox(height: 10),
                        TextButton(
                          onPressed: _loading
                              ? null
                              : () => Navigator.of(context).push(
                                    MaterialPageRoute(builder: (_) => const RegisterPage()),
                                  ),
                          child: const Text('Create an account'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

String _authMessage(FirebaseAuthException error) {
  return switch (error.code) {
    'invalid-email' => 'Email address is invalid.',
    'user-disabled' => 'This account has been disabled.',
    'user-not-found' || 'wrong-password' || 'invalid-credential' => 'Email or password is incorrect.',
    'network-request-failed' => 'Network error. Check your connection and try again.',
    _ => error.message ?? 'Login failed.',
  };
}
