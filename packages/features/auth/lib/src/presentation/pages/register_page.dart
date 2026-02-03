import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/auth_providers.dart';
import '../../providers/auth_state.dart';
import '../navigation/auth_navigation.dart';
import '../navigation/auth_navigation_provider.dart';

/// Registration page for new users.
class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onRegister() {
    if (_formKey.currentState?.validate() ?? false) {
      ref.read(authProvider.notifier).register(
            email: _emailController.text.trim(),
            password: _passwordController.text,
            name: _nameController.text.trim(),
          );
    }
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!value.contains('@')) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final AuthNavigationDelegate nav = AuthNavigationProvider.of(context);
    final AuthState state = ref.watch(authProvider);

    // Listen for errors and show snackbar
    ref.listen<AuthState>(authProvider, (AuthState? previous, AuthState next) {
      if (next is AuthError) {
        AppSnackbar.error(context: context, message: next.message);
      }
    });

    final bool isLoading = state is AuthLoading;

    return AppScaffold(
      title: 'Sign Up',
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => nav.navigateBack(context),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.paddingXl,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                AppSpacing.gapXl,
                Text(
                  'Create Account',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                AppSpacing.gapSm,
                Text(
                  'Sign up to get started',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.7),
                      ),
                  textAlign: TextAlign.center,
                ),
                AppSpacing.gapXxl,
                AppTextField(
                  controller: _nameController,
                  label: 'Name',
                  prefixIcon: Icons.person_outline,
                  validator: _validateName,
                  enabled: !isLoading,
                  textInputAction: TextInputAction.next,
                ),
                AppSpacing.gapLg,
                AppTextField.email(
                  controller: _emailController,
                  validator: _validateEmail,
                  enabled: !isLoading,
                ),
                AppSpacing.gapLg,
                AppPasswordField(
                  controller: _passwordController,
                  validator: _validatePassword,
                  enabled: !isLoading,
                  textInputAction: TextInputAction.next,
                ),
                AppSpacing.gapLg,
                AppPasswordField(
                  controller: _confirmPasswordController,
                  label: 'Confirm Password',
                  validator: _validateConfirmPassword,
                  enabled: !isLoading,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _onRegister(),
                ),
                AppSpacing.gapXl,
                AppButton.primary(
                  onPressed: isLoading ? null : _onRegister,
                  label: 'Sign Up',
                  isLoading: isLoading,
                  isExpanded: true,
                ),
                AppSpacing.gapLg,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Already have an account?',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    AppButton.text(
                      onPressed: isLoading ? null : () => nav.navigateBack(context),
                      label: 'Login',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
