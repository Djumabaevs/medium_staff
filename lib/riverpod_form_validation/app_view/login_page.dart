import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LoginView extends HookConsumerWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final email = useTextEditingController();
    final password = useTextEditingController();

    ref.listen(authNotifierProvider, (previous, next) {
      next.maybeWhen(
        orElse: () => null,
        authenticated: (user) {
          // Navigate to any screen
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('User Logged In'),
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

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Consumer(
                builder: (context, ref, _) {
                  final emailField =
                      ref.watch(loginFormNotifierProvider).form.email;
                  return CustomTextField(
                    onChanged: (value) => ref
                        .read(loginFormNotifierProvider.notifier)
                        .setEmail(value),
                    controller: email,
                    hintText: 'Email',
                    errorMessage: emailField.errorMessage,
                  );
                },
              ),
              const SizedBox(height: 30),
              Consumer(builder: (context, ref, _) {
                final passwordField =
                    ref.watch(loginFormNotifierProvider).form.password;
                return CustomTextField(
                  onChanged: (value) => ref
                      .read(loginFormNotifierProvider.notifier)
                      .setPassword(value),
                  controller: password,
                  errorMessage: passwordField.errorMessage,
                  isPassword: true,
                  hintText: 'Password',
                );
              }),
              const SizedBox(height: 40),
              Center(
                child: Consumer(builder: (context, ref, _) {
                  final field = ref.watch(loginFormNotifierProvider).form;
                  return CustomButton(
                    isDisabled:
                        !(field.password.isValid && field.email.isValid),
                    title: 'Sign in',
                    loading: ref
                        .watch(authNotifierProvider)
                        .maybeWhen(orElse: () => false, loading: () => true),
                    onPressed: () =>
                        ref.read(authNotifierProvider.notifier).login(
                              email: email.text,
                              password: password.text,
                            ),
                  );
                }),
              ),
              const SizedBox(height: 40),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Don\'t have account? '),
                  TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignupView(),
                      ),
                    ),
                    child: const Text('Signup'),
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
