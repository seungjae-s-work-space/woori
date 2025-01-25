// lib/presentation/auth/login_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_provider.dart';
import 'auth_state.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // AuthState 구독
    final authState = ref.watch(authNotifierProvider);

    // Email / Password 입력 컨트롤러
    final emailController = TextEditingController();
    final pwController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 에러가 있다면 표시
            if (authState.error != null) 
              Text(
                'Error: ${authState.error}',
                style: const TextStyle(color: Colors.red),
              ),
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
            if (authState.isLoading) 
              const CircularProgressIndicator()
            else
              ElevatedButton(
                onPressed: () async {
                  // 로딩 중이 아닐 때만 로그인 시도
                  final email = emailController.text.trim();
                  final pass = pwController.text.trim();

                  // login 호출
                  await ref.read(authNotifierProvider.notifier).login(email, pass);

                  // 로그인 성공 시, authState.token에 값이 있으므로
                  final token = ref.read(authNotifierProvider).token;
                  if (token != null) {
                    print('login success!');
                    // TODO: 로그인 성공시 이동할 화면 혹은 로직 추가
                    // Navigator.push(context, ...);
                  }
                },
                child: const Text('로그인'),
              ),
          ],
        ),
      ),
    );
  }
}
