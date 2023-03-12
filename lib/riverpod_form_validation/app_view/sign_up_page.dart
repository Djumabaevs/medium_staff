import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SignupView extends HookConsumerWidget {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(authNotifierProvider, (previous, next) {
      next.maybeWhen(
        orElse: () => null,
        authenticated: (user) {
          // Navigate to any screen
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('User Authenticated'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
        unauthenticated: (message) =>
            ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message!),
            behavior: SnackBarBehavior.floating,
          ),
        ),
      );
    });
    final email = useTextEditingController();
    final password = useTextEditingController();
    return Scaffold(
      appBar: AppBar(title: const Text('Signup')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: email,
                decoration: const InputDecoration(hintText: 'Email'),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: password,
                obscureText: true,
                decoration: const InputDecoration(hintText: 'Password'),
              ),
              const SizedBox(height: 40),
              Center(
                child: CustomButton(
                  title: 'Signup',
                  isDisabled: false,
                  onPressed: () =>
                      ref.read(authNotifierProvider.notifier).signup(
                            email: email.text,
                            password: password.text,
                          ),
                  loading: ref.watch(authNotifierProvider).maybeWhen(
                        orElse: () => false,
                        loading: () => true,
                      ),
                ),
              ),
              const SizedBox(height: 40),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already have Account? '),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Login'),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Center(
                child: SignInButton(
                  Buttons.GoogleDark,
                  onPressed: () => ref
                      .read(authNotifierProvider.notifier)
                      .continueWithGoogle(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
