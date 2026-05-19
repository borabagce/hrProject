import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../providers/auth_notifier.dart';
import '../widgets/login_form.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<AuthState> state = ref.watch(authNotifierProvider);
    final bool isBusy = state.isLoading ||
        (state.valueOrNull is AuthLoading);
    final String? error = switch (state.valueOrNull) {
      AuthUnauthenticated u => u.errorMessage,
      _ => null,
    };

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimens.spaceXl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(height: AppDimens.spaceXxl),
                const Icon(
                  Icons.analytics_rounded,
                  color: AppColors.primary,
                  size: 72,
                ).animate().fadeIn(duration: 400.ms).scale(),
                const SizedBox(height: AppDimens.spaceLg),
                Text(
                  AppStrings.loginTitle,
                  style: Theme.of(context).textTheme.displayMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppDimens.spaceXs),
                Text(
                  AppStrings.loginSubtitle,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppDimens.spaceXl),
                LoginForm(
                  isBusy: isBusy,
                  errorMessage: error,
                  onSubmit: (String email, String password) {
                    ref.read(authNotifierProvider.notifier).login(
                          email: email,
                          password: password,
                        );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
