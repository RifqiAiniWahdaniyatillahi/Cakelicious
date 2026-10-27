import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final confirmCtrl = TextEditingController();

  bool loading = false;
  String? error;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text(
                    'Register Cakelicious',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),

                  TextField(
                    controller: nameCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Nama Lengkap',
                    ),
                  ),
                  const SizedBox(height: 12),

                  TextField(
                    controller: emailCtrl,
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                  const SizedBox(height: 12),

                  TextField(
                    controller: passCtrl,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Password'),
                  ),
                  const SizedBox(height: 12),

                  TextField(
                    controller: confirmCtrl,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Konfirmasi Password',
                    ),
                  ),

                  if (error != null) ...[
                    const SizedBox(height: 12),
                    Text(error!, style: const TextStyle(color: Colors.red)),
                  ],

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed:
                          loading
                              ? null
                              : () async {
                                if (passCtrl.text != confirmCtrl.text) {
                                  setState(() {
                                    error = 'Password tidak sama';
                                  });
                                  return;
                                }

                                setState(() {
                                  loading = true;
                                  error = null;
                                });

                                final success = await auth.register(
                                  nameCtrl.text.trim(),
                                  emailCtrl.text.trim(),
                                  passCtrl.text,
                                );

                                setState(() => loading = false);

                                if (success) {
                                  Navigator.pushReplacementNamed(
                                    context,
                                    '/home',
                                  );
                                } else {
                                  setState(() {
                                    error = auth.lastError;
                                  });
                                }
                              },
                      child:
                          loading
                              ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                              : const Text('Register'),
                    ),
                  ),

                  TextButton(
                    onPressed:
                        () => Navigator.pushReplacementNamed(context, '/login'),
                    child: const Text('Sudah punya akun? Login'),
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
