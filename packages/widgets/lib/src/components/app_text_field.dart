import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A customizable text field widget with validation support.
///
/// Provides consistent styling from the theme with support for
/// validation, error states, and various input types.
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.label,
    this.hint,
    this.errorText,
    this.helperText,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.inputFormatters,
    this.semanticLabel,
    this.textCapitalization = TextCapitalization.none,
    this.autocorrect = true,
    this.enableSuggestions = true,
  });

  /// Creates an email text field with appropriate keyboard
  const AppTextField.email({
    super.key,
    this.controller,
    this.focusNode,
    this.label = 'Email',
    this.hint,
    this.errorText,
    this.helperText,
    this.prefixIcon = Icons.email_outlined,
    this.suffixIcon,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.validator,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.semanticLabel,
  })  : keyboardType = TextInputType.emailAddress,
        textInputAction = TextInputAction.next,
        obscureText = false,
        maxLines = 1,
        minLines = null,
        maxLength = null,
        inputFormatters = null,
        textCapitalization = TextCapitalization.none,
        autocorrect = false,
        enableSuggestions = false;

  /// Creates a multiline text area
  const AppTextField.multiline({
    super.key,
    this.controller,
    this.focusNode,
    this.label,
    this.hint,
    this.errorText,
    this.helperText,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.validator,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.maxLines = 5,
    this.minLines = 3,
    this.maxLength,
    this.semanticLabel,
  })  : keyboardType = TextInputType.multiline,
        textInputAction = TextInputAction.newline,
        obscureText = false,
        inputFormatters = null,
        textCapitalization = TextCapitalization.sentences,
        autocorrect = true,
        enableSuggestions = true;

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? label;
  final String? hint;
  final String? errorText;
  final String? helperText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final String? semanticLabel;
  final TextCapitalization textCapitalization;
  final bool autocorrect;
  final bool enableSuggestions;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Semantics(
      textField: true,
      enabled: enabled,
      label: semanticLabel ?? label,
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          errorText: errorText,
          helperText: helperText,
          prefixIcon: prefixIcon != null
              ? Icon(prefixIcon, color: theme.colorScheme.onSurface)
              : null,
          suffixIcon: suffixIcon != null
              ? Icon(suffixIcon, color: theme.colorScheme.onSurface)
              : null,
        ),
        onChanged: onChanged,
        onFieldSubmitted: onSubmitted,
        onTap: onTap,
        validator: validator,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        obscureText: obscureText,
        enabled: enabled,
        readOnly: readOnly,
        autofocus: autofocus,
        maxLines: maxLines,
        minLines: minLines,
        maxLength: maxLength,
        inputFormatters: inputFormatters,
        textCapitalization: textCapitalization,
        autocorrect: autocorrect,
        enableSuggestions: enableSuggestions,
      ),
    );
  }
}

/// Password text field with visibility toggle.
///
/// A specialized text field for password input with an
/// integrated visibility toggle button.
class AppPasswordField extends StatefulWidget {
  const AppPasswordField({
    super.key,
    this.controller,
    this.focusNode,
    this.label = 'Password',
    this.hint,
    this.errorText,
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.enabled = true,
    this.autofocus = false,
    this.textInputAction = TextInputAction.done,
    this.semanticLabel,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? label;
  final String? hint;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final String? Function(String?)? validator;
  final bool enabled;
  final bool autofocus;
  final TextInputAction textInputAction;
  final String? semanticLabel;

  @override
  State<AppPasswordField> createState() => _AppPasswordFieldState();
}

class _AppPasswordFieldState extends State<AppPasswordField> {
  bool _obscureText = true;

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Semantics(
      textField: true,
      enabled: widget.enabled,
      label: widget.semanticLabel ?? widget.label ?? 'Password',
      child: TextFormField(
        controller: widget.controller,
        focusNode: widget.focusNode,
        decoration: InputDecoration(
          labelText: widget.label,
          hintText: widget.hint,
          errorText: widget.errorText,
          prefixIcon: Icon(
            Icons.lock_outline,
            color: theme.colorScheme.onSurface,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              _obscureText
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: theme.colorScheme.onSurface,
            ),
            onPressed: _toggleVisibility,
            tooltip: _obscureText ? 'Show password' : 'Hide password',
          ),
        ),
        onChanged: widget.onChanged,
        onFieldSubmitted: widget.onSubmitted,
        validator: widget.validator,
        keyboardType: TextInputType.visiblePassword,
        textInputAction: widget.textInputAction,
        obscureText: _obscureText,
        enabled: widget.enabled,
        autofocus: widget.autofocus,
        autocorrect: false,
        enableSuggestions: false,
      ),
    );
  }
}
