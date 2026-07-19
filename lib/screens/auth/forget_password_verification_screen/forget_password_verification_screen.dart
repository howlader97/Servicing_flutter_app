import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_template/constant/app_asserts_icons_path.dart';
import 'package:flutter_riverpod_template/constant/app_colors.dart';
import 'package:flutter_riverpod_template/routes/app_routes.dart';
import 'package:flutter_riverpod_template/routes/app_routes_key.dart';
import 'package:flutter_riverpod_template/screens/auth/forget_password_screen/provider/forget_password_provider.dart';
import 'package:flutter_riverpod_template/screens/auth/forget_password_verification_screen/provider/forget_password_verification_provider.dart';
import 'package:flutter_riverpod_template/utils/app_size.dart';
import 'package:flutter_riverpod_template/utils/app_snack_bar.dart';
import 'package:flutter_riverpod_template/utils/gap.dart';
import 'package:flutter_riverpod_template/widgets/buttons/app_button.dart';
import 'package:flutter_riverpod_template/widgets/inputs/app_input_widget_tow.dart';
import 'package:flutter_riverpod_template/widgets/texts/app_text.dart';

class ForgetPasswordVerificationScreen extends ConsumerStatefulWidget {
  const ForgetPasswordVerificationScreen({super.key});

  @override
  ConsumerState<ForgetPasswordVerificationScreen> createState() => _ForgetPasswordVerificationScreenState();
}

class _ForgetPasswordVerificationScreenState extends ConsumerState<ForgetPasswordVerificationScreen> {

  late TextEditingController otpController;

  @override
  void initState() {
    otpController = TextEditingController();
    super.initState();
  }
  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    String maskEmail(String email) {
      if (email.isEmpty) return "";
      final parts = email.split('@');
      if (parts.length != 2) return email;
      final username = parts[0];
      final domain = parts[1];
      if (username.length <= 3) {
        return "${username.substring(0, 1)}***@$domain";
      }
      return "${username.substring(0, 3)}******@$domain";
    }

    final verifyState = ref.watch(forgetPasswordVerificationProvider);
    final resendState = ref.watch(forgetPasswordResendOtpProvider);
    final email = ref.watch(forgotPasswordEmailProvider);
    final isLoading = verifyState.isLoading || resendState.isLoading;

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
                    text: "Enter Code",
                    fontSize: 32,
                    fontWeight: FontWeight.w400,
                    color: AppColors.instance.textHeading,
                  ),
                  Gap(height: 10),
                  AppText(
                    text: "We sent code to your Gmail",
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: AppColors.instance.textColor,
                  ),
                  AppText(
                    text: maskEmail(email),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: AppColors.instance.textColor,
                  ),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Gap(height: AppSize.height(value: 50)),
                  AppInputWidgetTwo(
                    controller: otpController,
                    title: "Code",
                    hintText: "Input code",
                    titleColor: AppColors.instance.textHeading,
                  ),
                  Gap(height: AppSize.height(value: 20)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        AppText(
                          text: "If you didn't receive a code?",
                          color: AppColors.instance.textColor,
                          fontSize: 16,
                        ),
                        Gap(width: 5),
                        GestureDetector(
                          onTap: isLoading
                              ? null
                              : () async {
                                  if (email.isEmpty) {
                                    AppSnackBar.instance.error("Email address not found. Please try again.");
                                    return;
                                  }
                                  await ref.read(forgetPasswordResendOtpProvider.notifier).resend(email);
                                },
                          child: AppText(
                            text: "Resend",
                            color: AppColors.instance.textColor,
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Gap(height: AppSize.height(value: 20)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: AppButton(
                      onTap: () async {
                        final code = otpController.text.trim();
                        if (code.isEmpty) {
                          AppSnackBar.instance.error("Please enter the verification code");
                          return;
                        }
                        if (email.isEmpty) {
                          AppSnackBar.instance.error("Email address not found. Please try again.");
                          return;
                        }
                        final success = await ref
                            .read(forgetPasswordVerificationProvider.notifier)
                            .verify(email, code);
                        if (success) {
                          AppRoutes.instance.push(
                            AppRoutesKey.instance.resetPasswordScreen,
                          );
                        }
                      },
                      isLoading: isLoading,
                      height: AppSize.height(value: 46),
                      backgroundColor: AppColors.instance.primary,
                      title: "Verify",
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
