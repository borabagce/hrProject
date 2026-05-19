import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    required this.onSubmit,
    required this.isBusy,
    this.errorMessage,
    super.key,
  });

  final void Function(String email, String password) onSubmit;
  final bool isBusy;
  final String? errorMessage;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _obscure = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _onPressed() {
    if (!_formKey.currentState!.validate()) return;
    widget.onSubmit(_email.text.trim(), _password.text);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextFormField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            autofillHints: const <String>[AutofillHints.email],
            decoration: const InputDecoration(
              labelText: AppStrings.emailLabel,
              prefixIcon: Icon(Icons.mail_outline_rounded),
            ),
            validator: (String? v) {
              if (v == null || v.isEmpty) return 'E-posta gerekli';
              if (!v.contains('@')) return 'Geçerli bir e-posta girin';
              return null;
            },
          ),
          const SizedBox(height: AppDimens.spaceMd),
          TextFormField(
            controller: _password,
            obscureText: _obscure,
            autofillHints: const <String>[AutofillHints.password],
            decoration: InputDecoration(
              labelText: AppStrings.passwordLabel,
              prefixIcon: const Icon(Icons.lock_outline_rounded),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                ),
                onPressed: () => setState(() => _obscure = !_obscure),
              ),
            ),
            validator: (String? v) =>
                (v == null || v.length < 6) ? 'Şifre çok kısa' : null,
          ),
          const SizedBox(height: AppDimens.spaceLg),
          if (widget.errorMessage != null) ...<Widget>[
            Container(
              padding: const EdgeInsets.all(AppDimens.spaceMd),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.08),
                borderRadius: BorderRadius.circular(AppDimens.radiusMd),
              ),
              child: Row(
                children: <Widget>[
                  const Icon(Icons.error_outline, color: AppColors.error, size: 20),
                  const SizedBox(width: AppDimens.spaceSm),
                  Expanded(
                    child: Text(
                      AppStrings.loginFailed,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.error,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimens.spaceMd),
          ],
          ElevatedButton(
            onPressed: widget.isBusy ? null : _onPressed,
            child: widget.isBusy
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text(AppStrings.loginButton),
          ),
        ],
      ),
    );
  }
}
