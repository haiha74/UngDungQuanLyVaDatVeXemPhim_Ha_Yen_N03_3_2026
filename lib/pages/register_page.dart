import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/user_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  static const routeName = '/register';

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _userService = UserService();
  bool _loading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      final user = credential.user;
      if (user == null) {
        throw FirebaseAuthException(code: 'missing-user', message: 'Registration did not return a user.');
      }

      await user.updateDisplayName(_fullNameController.text.trim());
      await _userService.saveAuthenticatedUser(
        uid: user.uid,
        fullName: _fullNameController.text,
        email: _emailController.text,
      );

      if (!mounted) return;
      Navigator.of(context).popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (error) {
      _showError(_authMessage(error));
    } catch (error) {
      _showError('Registration failed: $error');
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
      appBar: AppBar(title: const Text('Register')),
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
                        Text(
                          'Create account',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _fullNameController,
                          decoration: const InputDecoration(
                            labelText: 'Full name',
                            prefixIcon: Icon(Icons.person_outline),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) => value == null || value.trim().length < 2 ? 'Enter your full name' : null,
                        ),
                        const SizedBox(height: 12),
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
                          onPressed: _loading ? null : _register,
                          icon: _loading
                              ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                              : const Icon(Icons.person_add_alt_1),
                          label: const Text('Register'),
                        ),
                        const SizedBox(height: 10),
                        TextButton(
                          onPressed: _loading ? null : () => Navigator.of(context).pop(),
                          child: const Text('Back to login'),
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
    'email-already-in-use' => 'This email is already registered.',
    'invalid-email' => 'Email address is invalid.',
    'weak-password' => 'Password is too weak.',
    'network-request-failed' => 'Network error. Check your connection and try again.',
    _ => error.message ?? 'Registration failed.',
  };
}
