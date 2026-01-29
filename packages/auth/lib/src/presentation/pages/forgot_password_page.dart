import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:widgets/widgets.dart';

import '../bloc/auth_bloc.dart';
import '../navigation/auth_navigation_provider.dart';

/// Forgot password page for password recovery.
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
            ForgotPasswordRequested(email: _emailController.text.trim()),
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

  @override
  Widget build(BuildContext context) {
    final nav = AuthNavigationProvider.of(context);

    return AppScaffold(
      title: 'Forgot Password',
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => nav.navigateBack(context),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            AppSnackbar.error(context: context, message: state.message);
          } else if (state is AuthPasswordResetSent) {
            AppSnackbar.success(
              context: context,
              message: 'Password reset link sent to your email',
            );
            nav.navigateBack(context);
          }
        },
        builder: (context, state) {
          final bool isLoading = state is AuthLoading;

          return SafeArea(
            child: SingleChildScrollView(
              padding: AppSpacing.paddingXl,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppSpacing.gapXxl,
                    Icon(
                      Icons.lock_reset,
                      size: 64,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    AppSpacing.gapXl,
                    Text(
                      'Reset Password',
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    AppSpacing.gapSm,
                    Text(
                      'Enter your email address and we will send you a link to reset your password.',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                      textAlign: TextAlign.center,
                    ),
                    AppSpacing.gapXxl,
                    AppTextField.email(
                      controller: _emailController,
                      validator: _validateEmail,
                      enabled: !isLoading,
                      onSubmitted: (_) => _onSubmit(),
                    ),
                    AppSpacing.gapXl,
                    AppButton.primary(
                      onPressed: isLoading ? null : _onSubmit,
                      label: 'Send Reset Link',
                      isLoading: isLoading,
                      isExpanded: true,
                    ),
                    AppSpacing.gapLg,
                    AppButton.text(
                      onPressed: isLoading ? null : () => nav.navigateBack(context),
                      label: 'Back to Login',
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
