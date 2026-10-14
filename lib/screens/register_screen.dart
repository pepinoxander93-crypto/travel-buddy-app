import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../theme/app_theme.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _user = TextEditingController();
  final _email = TextEditingController();
  final _pass = TextEditingController();
  String? _msg;
  bool _obscure = true;

  Future<void> _submit() async {
    final ok = await AuthService.register(
        _user.text.trim(), _email.text.trim(), _pass.text);
    if (!mounted) return;
    setState(() => _msg = ok
        ? 'Registration successful! Please login.'
        : 'Email already exists.');
    if (ok) {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) Navigator.pop(context);
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
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Create Account',
                      style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: AppColors.blue)),
                  const SizedBox(height: 20),

                  // Username
                  TextField(
                    controller: _user,
                    decoration:
                        const InputDecoration(hintText: 'Username'),
                  ),
                  const SizedBox(height: 12),

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
                        onPressed: _submit, child: const Text('Register')),
                  ),
                  if (_msg != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(_msg!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: _msg!.startsWith('Registration')
                                  ? Colors.green
                                  : Colors.red)),
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