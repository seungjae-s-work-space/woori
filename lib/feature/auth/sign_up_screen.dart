// lib/presentation/auth/sign_up_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_provider.dart';

class SignUpScreen extends ConsumerWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);

    final emailController = TextEditingController();
    final pwController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (authState.error != null) Text('Error: ${authState.error}'),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: pwController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: authState.isLoading
                  ? null
                  : () async {
                      final email = emailController.text.trim();
                      final pass = pwController.text.trim();
                      await ref
                          .read(authNotifierProvider.notifier)
                          .signUp(email, pass);
                    },
              child: authState.isLoading
                  ? const CircularProgressIndicator()
                  : const Text('회원가입'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              child: const Text('로그인하러 가기'),
            ),
          ],
        ),
      ),
    );
  }
}
