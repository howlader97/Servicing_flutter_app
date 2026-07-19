import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_template/constant/app_asserts_icons_path.dart';
import 'package:flutter_riverpod_template/constant/app_colors.dart';
import 'package:flutter_riverpod_template/routes/app_routes.dart';
import 'package:flutter_riverpod_template/routes/app_routes_key.dart';
import 'package:flutter_riverpod_template/screens/auth/forget_password_screen/provider/forget_password_provider.dart';
import 'package:flutter_riverpod_template/screens/auth/forget_password_verification_screen/provider/forget_password_verification_provider.dart';
import 'package:flutter_riverpod_template/screens/auth/reset_password_screen/provider/reset_password_provider.dart';
import 'package:flutter_riverpod_template/utils/app_size.dart';
import 'package:flutter_riverpod_template/utils/app_snack_bar.dart';
import 'package:flutter_riverpod_template/utils/gap.dart';
import 'package:flutter_riverpod_template/widgets/buttons/app_button.dart';
import 'package:flutter_riverpod_template/widgets/inputs/app_input_widget_tow.dart';
import 'package:flutter_riverpod_template/widgets/texts/app_text.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  ConsumerState<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  late TextEditingController newPasswordController;
  late TextEditingController confirmPasswordController;

  @override
  void initState() {
    newPasswordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final resetState = ref.watch(resetPasswordProvider);
    final isLoading = resetState.isLoading;
    final email = ref.watch(forgotPasswordEmailProvider);
    final code = ref.watch(forgotPasswordOtpProvider);

    return Scaffold(
      backgroundColor: AppColors.instance.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Gap(height: 5),
                  Image.asset(
                    AppAssertsIconsPath.instance.splashIcon,
                    scale: 5,
                  ),
                  Gap(height: 12),
                  AppText(
                    text: "Create new password",
                    fontSize: 32,
                    fontWeight: FontWeight.w400,
                    color: AppColors.instance.textHeading,
                  ),
                  Gap(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: AppText(
                      text: "Keep your account safe with a unique numeric password",
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      textAlign: TextAlign.center,
                      color: AppColors.instance.textColor,
                    ),
                  ),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Gap(height: AppSize.height(value: 50)),
                  AppInputWidgetTwo(
                    controller: newPasswordController,
                    title: "New Password",
                    hintText: "*****",
                    titleColor: AppColors.instance.textHeading,
                  ),
                  AppInputWidgetTwo(
                    controller: confirmPasswordController,
                    title: "Confirm Password",
                    hintText: "*****",
                    titleColor: AppColors.instance.textHeading,
                  ),
                  Gap(height: AppSize.height(value: 30)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: AppButton(
                      onTap: () async {
                        final password = newPasswordController.text.trim();
                        final confirmPassword = confirmPasswordController.text.trim();

                        if (password.isEmpty) {
                          AppSnackBar.instance.error("Please enter new password");
                          return;
                        }
                        if (confirmPassword.isEmpty) {
                          AppSnackBar.instance.error("Please confirm new password");
                          return;
                        }
                        if (password != confirmPassword) {
                          AppSnackBar.instance.error("Passwords do not match");
                          return;
                        }
                        if (email.isEmpty || code.isEmpty) {
                          AppSnackBar.instance.error("Session expired. Please request a code again.");
                          return;
                        }

                        final success = await ref.read(resetPasswordProvider.notifier).reset(
                              email: email,
                              code: code,
                              password: password,
                              confirmPassword: confirmPassword,
                            );

                        if (success) {
                          AppRoutes.instance.go(
                            AppRoutesKey.instance.loginScreen,
                          );
                        }
                      },
                      isLoading: isLoading,
                      height: AppSize.height(value: 46),
                      backgroundColor: AppColors.instance.primary,
                      title: "Update Password",
                    ),
                  ),
                  Gap(height: AppSize.height(value: 25)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
