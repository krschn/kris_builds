import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/auth_providers.dart';
import '../../providers/auth_state.dart';
import '../navigation/auth_navigation.dart';
import '../navigation/auth_navigation_provider.dart';

/// Login page for user authentication.
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      ref.read(authProvider.notifier).login(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );
    }
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
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
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
      title: 'Login',
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.paddingXl,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                AppSpacing.gapXxl,
                Text(
                  'Welcome Back',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                AppSpacing.gapSm,
                Text(
                  'Sign in to continue',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.7),
                      ),
                  textAlign: TextAlign.center,
                ),
                AppSpacing.gapXxl,
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
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _onLogin(),
                ),
                AppSpacing.gapMd,
                Align(
                  alignment: Alignment.centerRight,
                  child: AppButton.text(
                    onPressed:
                        isLoading ? null : () => nav.navigateToForgotPassword(context),
                    label: 'Forgot Password?',
                  ),
                ),
                AppSpacing.gapXl,
                AppButton.primary(
                  onPressed: isLoading ? null : _onLogin,
                  label: 'Login',
                  isLoading: isLoading,
                  isExpanded: true,
                ),
                AppSpacing.gapLg,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Don't have an account?",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    AppButton.text(
                      onPressed:
                          isLoading ? null : () => nav.navigateToRegister(context),
                      label: 'Sign Up',
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
