import 'package:flutter/material.dart';

import '../../domain/validators/auth_validator.dart';
import '../state/auth_state.dart';

class SignUpScreen extends StatefulWidget {
  final AuthState authState;
  final VoidCallback onSignUpSuccess;
  final VoidCallback onGoToLogin;

  const SignUpScreen({
    super.key,
    required this.authState,
    required this.onSignUpSuccess,
    required this.onGoToLogin,
  });

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void initState() {
    super.initState();
    widget.authState.addListener(_onStateChanged);
  }

  @override
  void dispose() {
    widget.authState.removeListener(_onStateChanged);
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _onStateChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    widget.authState.clearError();

    final success = await widget.authState.signUp(
      _emailController.text.trim(),
      _passwordController.text,
    );
    if (success && mounted) {
      widget.onSignUpSuccess();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = widget.authState;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('🐱', style: TextStyle(fontSize: 80)),
                  const SizedBox(height: 8),
                  Text(
                    'Catinder',
                    style: theme.textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email_outlined),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: AuthValidator.validateEmail,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () =>
                            setState(() => _obscurePassword = !_obscurePassword),
                      ),
                    ),
                    obscureText: _obscurePassword,
                    textInputAction: TextInputAction.next,
                    validator: AuthValidator.validatePassword,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _confirmController,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(_obscureConfirm
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () =>
                            setState(() => _obscureConfirm = !_obscureConfirm),
                      ),
                    ),
                    obscureText: _obscureConfirm,
                    textInputAction: TextInputAction.done,
                    validator: (v) => AuthValidator.validatePasswordConfirm(
                        v, _passwordController.text),
                    onFieldSubmitted: (_) => _submit(),
                  ),
                  if (state.error != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      state.error!,
                      style: TextStyle(color: theme.colorScheme.error),
                    ),
                  ],
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: FilledButton(
                      onPressed: state.isLoading ? null : _submit,
                      child: state.isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Sign Up'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: widget.onGoToLogin,
                    child: const Text('Already have an account? Log in'),
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
