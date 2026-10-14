import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';
import 'register_screen.dart';
import 'destinations_screen.dart';
import 'admin_dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _pass = TextEditingController();
  String? _error;
  bool _obscure = true;

  Future<void> _submit() async {
    final ok = await AuthService.login(_email.text.trim(), _pass.text);
    if (!mounted) return;
    if (ok) {
      final isAdmin = StorageService.isAdmin;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => isAdmin
              ? const AdminDashboardScreen()
              : const DestinationsScreen(),
        ),
      );
    } else {
      setState(() => _error = 'Invalid email or password');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: AppTheme.bgGradient,
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 30,
                    offset: const Offset(0, 15),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ===== LOGO =====
                  Image.asset(
                    'assets/travel_buddy.png',
                    width: 100,
                    height: 100,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 20),
                  const Text('Travel Buddy',
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: AppColors.blue)),
                  const SizedBox(height: 8),
                  const Text('Welcome back!',
                      style: TextStyle(color: AppColors.muted)),
                  const SizedBox(height: 24),
                  if (_error != null)
                    Text(_error!,
                        style: const TextStyle(color: Colors.red)),

                  // Email
                  TextField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(hintText: 'Email'),
                  ),
                  const SizedBox(height: 12),

                  // Password with show/hide
                  TextField(
                    controller: _pass,
                    obscureText: _obscure,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscure
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: AppColors.muted,
                        ),
                        onPressed: () =>
                            setState(() => _obscure = !_obscure),
                        tooltip: _obscure
                            ? 'Show password'
                            : 'Hide password',
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: _submit, child: const Text('Login')),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const RegisterScreen())),
                    child: const Text('Create an account',
                        style: TextStyle(color: AppColors.coral)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}